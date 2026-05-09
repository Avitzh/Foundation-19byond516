/obj/item/calculator
	name = "calculator"
	desc = "A portable electronic calculator with scientific functions."
	icon = 'icons/obj/pda.dmi'
	icon_state = "pai"
	w_class = ITEM_SIZE_SMALL

	var/expression = ""
	var/result = ""
	var/list/history = list()
	var/radians = FALSE   // TRUE - радианы, FALSE - градусы

// ------------------ Интерфейсные методы ------------------
/obj/item/calculator/attack_self(mob/user)
	..()
	if(!user.ckey)
		return
	tgui_interact(user)

/obj/item/calculator/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Calculator", "Calculator")
		ui.open()

/obj/item/calculator/tgui_data(mob/user)
	var/list/data = ..()
	data["expression"] = expression
	data["result"] = result
	data["history"] = history
	data["radians"] = radians
	return data

/obj/item/calculator/tgui_act(action, list/params, datum/tgui/ui)
	if(..())
		return TRUE
	. = TRUE
	switch(action)
		if("append")
			expression += params["value"]
		if("clear")
			expression = ""
			result = ""
		if("backspace")
			expression = copytext(expression, 1, length(expression))
		if("evaluate")
			result = calculate(expression)
		if("clear_history")
			history.Cut()
		if("toggle_mode")
			radians = !radians
		if("integral")
			var/func = input(usr, "Введите функцию от x (например, x^2, sin(x), 2*x+1):", "Интеграл") as text|null
			if(!func)
				return
			var/lower = input(usr, "Нижний предел (a):", "Интеграл") as num|null
			if(isnull(lower))
				return
			var/upper = input(usr, "Верхний предел (b):", "Интеграл") as num|null
			if(isnull(upper))
				return
			var/steps = input(usr, "Количество шагов (точность):", "Интеграл", 100) as num|null
			if(isnull(steps) || steps < 2)
				steps = 100
			result = calculate_integral(func, lower, upper, steps)
			history.Add("∫ [func] dx from [lower] to [upper] = [result]")
		else
			. = FALSE
	if(.)
		SStgui.update_uis(src)

// ------------------ Вычислительное ядро ------------------
/obj/item/calculator/proc/calculate(expr)
	expr = trim(expr)
	if(!length(expr))
		return "Error"

	// Проверка допустимых символов: цифры, буквы, операторы, точка, скобки
	var/static/list/valid_chars = list(
		"0","1","2","3","4","5","6","7","8","9",
		".", " ", "+", "-", "*", "/", "^", "%", "(", ")", ","
	)
	for(var/i = 1 to length(expr))
		var/char = copytext(expr, i, i+1)
		if(!(char in valid_chars))
			var/ascii = text2ascii(char)
			if(!(ascii >= 65 && ascii <= 90) && !(ascii >= 97 && ascii <= 122))
				return "Invalid characters: [char]"

	var/eval_expr = expr

	// 1. Обработка процентов (до тригонометрии)
	var/regex/pct_binary = new(@"(\d+(?:\.\d+)?)\s*%\s*(\d+(?:\.\d+)?)", "g")
	eval_expr = pct_binary.Replace(eval_expr, "($1*$2/100)")
	var/regex/pct_unary = new(@"(\d+(?:\.\d+)?)%", "g")
	eval_expr = pct_unary.Replace(eval_expr, "($1/100)")

	// 2. Тригонометрические функции в градусах/радианах
	if(!radians)
		// Оборачиваем аргументы целиком с помощью регулярных выражений
		// sin(аргумент) -> sin(deg2rad(аргумент))
		var/regex/sin_re = new(@"sin\(([^)]+)\)", "g")
		eval_expr = sin_re.Replace(eval_expr, "sin(deg2rad($1))")
		var/regex/cos_re = new(@"cos\(([^)]+)\)", "g")
		eval_expr = cos_re.Replace(eval_expr, "cos(deg2rad($1))")
		var/regex/tan_re = new(@"tan\(([^)]+)\)", "g")
		eval_expr = tan_re.Replace(eval_expr, "tan(deg2rad($1))")
		// asin(аргумент) -> rad2deg(asin(аргумент))
		var/regex/asin_re = new(@"asin\(([^)]+)\)", "g")
		eval_expr = asin_re.Replace(eval_expr, "rad2deg(asin($1))")
		var/regex/acos_re = new(@"acos\(([^)]+)\)", "g")
		eval_expr = acos_re.Replace(eval_expr, "rad2deg(acos($1))")
		var/regex/atan_re = new(@"atan\(([^)]+)\)", "g")
		eval_expr = atan_re.Replace(eval_expr, "rad2deg(atan($1))")

	// 3. Замена констант
	eval_expr = replacetext(eval_expr, "pi", "3.141592653589793")
	eval_expr = replacetext(eval_expr, "PI", "3.141592653589793")

	// 4. Парсер / вычислитель
	var/parsed = parse_expression(eval_expr)
	if(isnum(parsed))
		history.Add("[expr] = [parsed]")
		return "[parsed]"
	else
		return "[parsed]"

// ------------------ Парсер (shunting-yard) ------------------
/proc/parse_expression(expr)
	var/list/output = list()
	var/list/op_stack = list()

	var/i = 1
	while(i <= length(expr))
		var/char = copytext(expr, i, i+1)
		if(char == " ")
			i++
			continue

		// Число
		if(is_digit(char) || (char == "." && i < length(expr) && is_digit(copytext(expr, i+1, i+2))))
			var/num_start = i
			var/has_dot = FALSE
			if(char == ".")
				has_dot = TRUE
			i++
			while(i <= length(expr))
				var/cc = copytext(expr, i, i+1)
				if(is_digit(cc))
					i++
				else if(cc == "." && !has_dot)
					has_dot = TRUE
					i++
				else
					break
			var/num_str = copytext(expr, num_start, i)
			var/num_val = text2num(num_str)
			if(isnull(num_val))
				return "Error: bad number [num_str]"
			output[++output.len] = num_val
			continue

		// Константа pi
		if(char == "p" && i+1 <= length(expr) && copytext(expr, i, i+2) == "pi")
			if(i+2 >= length(expr) || !is_alphanumeric(copytext(expr, i+2, i+3)))
				output[++output.len] = 3.141592653589793
				i += 2
				continue

		// Функция (имя с буквами и цифрами)
		if(is_letter(char))
			var/func_start = i
			while(i <= length(expr) && is_alphanumeric(copytext(expr, i, i+1)))
				i++
			var/func_name = copytext(expr, func_start, i)
			if(i > length(expr) || copytext(expr, i, i+1) != "(")
				return "Error: expected '(' after function [func_name]"
			op_stack[++op_stack.len] = list("func", func_name)
			op_stack[++op_stack.len] = list("lparen")
			i++ // пропускаем '('
			continue

		// Левая скобка '('
		if(char == "(")
			op_stack[++op_stack.len] = list("lparen")
			i++
			continue

		// Правая скобка ')'
		if(char == ")")
			while(op_stack.len > 0)
				var/list/top = op_stack[op_stack.len]
				if(top[1] == "lparen")
					op_stack.len--
					if(op_stack.len > 0)
						var/list/tmp = op_stack[op_stack.len]
						if(tmp[1] == "func")
							output[++output.len] = tmp
							op_stack.len--
					break
				else
					output[++output.len] = top
					op_stack.len--
			i++
			continue

		// Запятая (игнорируется)
		if(char == ",")
			i++
			continue

		// Операторы
		var/op = null
		var/op_type = null
		if(char == "+" || char == "-")
			var/unary = FALSE
			if((i == 1) || (copytext(expr, i-1, i) in list("(", "^", "*", "/", "+", "-")))
				unary = TRUE
			if(unary)
				op = "neg"
				op_type = "unary"
			else
				op = char
				op_type = "binary"
		else if(char == "*")
			op = "*"; op_type = "binary"
		else if(char == "/")
			op = "/"; op_type = "binary"
		else if(char == "^")
			op = "^"; op_type = "binary"
		else
			return "Error: unexpected symbol [char]"

		// Выталкивание по приоритетам
		if(op_type == "binary")
			while(op_stack.len > 0)
				var/list/top = op_stack[op_stack.len]
				if(top[1] == "lparen" || top[1] == "func")
					break
				if((top[1] == "binary" && precedence_binary(top[2]) >= precedence_binary(op)) || (top[1] == "unary" && precedence("unary") >= precedence_binary(op)))
					output[++output.len] = top
					op_stack.len--
				else
					break
		else
			while(op_stack.len > 0)
				var/list/top = op_stack[op_stack.len]
				if(top[1] == "lparen" || top[1] == "func")
					break
				if(top[1] == "unary" && precedence("unary") >= precedence("unary"))
					output[++output.len] = top
					op_stack.len--
				else if(top[1] == "binary" && precedence_binary(top[2]) >= precedence("unary"))
					output[++output.len] = top
					op_stack.len--
				else
					break

		op_stack[++op_stack.len] = list(op_type, op)
		i++

	// Выталкиваем всё оставшееся
	while(op_stack.len > 0)
		output[++output.len] = op_stack[op_stack.len]
		op_stack.len--

	return evaluate_rpn(output)

/proc/precedence_binary(op)
	switch(op)
		if("+", "-") return 1
		if("*", "/", "%") return 2
		if("^") return 4
	return 0

/proc/precedence(op_type)
	switch(op_type)
		if("unary") return 3
	return 0

/proc/is_digit(ch)
	var/ascii = text2ascii(ch)
	return (ascii >= 48 && ascii <= 57)

/proc/is_letter(ch)
	var/ascii = text2ascii(ch)
	return (ascii >= 65 && ascii <= 90) || (ascii >= 97 && ascii <= 122)

/proc/is_alphanumeric(ch)
	return is_letter(ch) || is_digit(ch)

/proc/evaluate_rpn(list/rpn)
	var/list/stack = list()
	for(var/item in rpn)
		if(isnum(item))
			stack[++stack.len] = item
		else if(islist(item))
			if(length(item) < 2)
				return "Error: malformed operator token"
			var/type = item[1]
			var/op_or_func = item[2]
			if(type == "binary")
				if(stack.len < 2)
					return "Error: not enough operands for [op_or_func]"
				var/b = stack[stack.len]; stack.len--
				var/a = stack[stack.len]; stack.len--
				var/res
				switch(op_or_func)
					if("+") res = a + b
					if("-") res = a - b
					if("*") res = a * b
					if("/")
						if(b == 0) return "Error: division by zero"
						res = a / b
					if("^") res = a ** b
				stack[++stack.len] = res
			else if(type == "unary")
				if(stack.len < 1)
					return "Error: not enough operands for unary [op_or_func]"
				var/a = stack[stack.len]; stack.len--
				if(op_or_func == "neg")
					stack[++stack.len] = -a
			else if(type == "func")
				if(stack.len < 1)
					return "Error: not enough arguments for [op_or_func]"
				var/arg = stack[stack.len]; stack.len--
				switch(op_or_func)
					if("sin") stack[++stack.len] = sin(arg)
					if("cos") stack[++stack.len] = cos(arg)
					if("tan") stack[++stack.len] = tan(arg)
					if("asin") stack[++stack.len] = arcsin(arg)
					if("acos") stack[++stack.len] = arccos(arg)
					if("atan") stack[++stack.len] = arctan(arg)
					if("deg2rad") stack[++stack.len] = deg2rad(arg)
					if("rad2deg") stack[++stack.len] = rad2deg(arg)
					else
						return "Error: unknown function [op_or_func]"
		else
			return "Error: unexpected token"
	if(stack.len != 1)
		return "Error: malformed expression"
	return stack[1]

// ------------------ Интеграл ------------------
/obj/item/calculator/proc/calculate_integral(func, a, b, steps)
	var/step_size = (b - a) / steps
	var/sum = 0
	for(var/i = 0 to steps-1)
		var/x = a + i * step_size
		var/expr = replacetext(func, "x", "[x]")
		var/calc_result = calculate(expr)
		var/y_text = text2num(calc_result)
		if(isnull(y_text))
			return "Error in integrand at x=[x]: [calc_result]"
		sum += y_text * step_size
	return "[sum]"
