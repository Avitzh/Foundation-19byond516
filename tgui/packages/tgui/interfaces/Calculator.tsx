import { useBackend } from '../backend';
import { Box, Button, Flex, Section, Stack } from '../components';
import { Window } from '../layouts';

type CalculatorData = {
  expression: string;
  result: string;
  history: string[];
  radians: boolean;
};

const BUTTONS = [
  ['7', '8', '9', '/'],
  ['4', '5', '6', '*'],
  ['1', '2', '3', '-'],
  ['0', '.', '^', '+'],
  ['%', '(', ')', 'Eval'],
  ['sin', 'cos', 'tan', 'π'],
  ['asin', 'acos', 'atan', '∫dx'],
  ['AC', '⌫', 'Deg/Rad', ''],
];

export const Calculator = (props, context) => {
  const { act, data } = useBackend<CalculatorData>(context);
  const { expression = '', result = '', history = [], radians } = data;

  return (
    <Window width={280} height={430} theme="retro">
      <Window.Content>
        <Stack vertical fill justify="space-between">
          <Stack.Item>
            <Section fill>
              <Box
                height="2em"
                fontSize="24px"
                textAlign="right"
                backgroundColor="black"
                color="lightgreen"
                p={1}>
                {expression || '0'}
              </Box>
              {result && (
                <Box
                  height="1.5em"
                  fontSize="18px"
                  textAlign="right"
                  backgroundColor="black"
                  color="yellow"
                  p={0.5}>
                  = {result}
                </Box>
              )}
              <Box mt={1} textAlign="center">
                <Button
                  onClick={() => act('toggle_mode')}
                  content={radians ? 'RAD' : 'DEG'}
                  color={radians ? 'blue' : 'orange'}
                />
              </Box>
            </Section>
          </Stack.Item>
          <Stack.Item>
            <Section fill>
              <Flex direction="column" justify="space-between" height="100%">
                {BUTTONS.map((row, rowIdx) => (
                  <Flex.Item key={rowIdx}>
                    <Flex justify="space-between">
                      {row.map((btn, colIdx) => {
                        if (!btn) {
                          return <Flex.Item key={colIdx} basis="25%" />;
                        }
                        let action = 'append';
                        let value = btn;
                        if (btn === 'Eval') {
                          action = 'evaluate';
                          value = '';
                        } else if (btn === 'AC') {
                          action = 'clear';
                          value = '';
                        } else if (btn === '⌫') {
                          action = 'backspace';
                          value = '';
                        } else if (btn === '∫dx') {
                          action = 'integral';
                          value = '';
                        } else if (btn === 'Deg/Rad') {
                          action = 'toggle_mode';
                          value = '';
                        } else if (['sin', 'cos', 'tan', 'asin', 'acos', 'atan'].includes(btn)) {
                          action = 'append';
                          value = btn + '(';
                        } else if (btn === 'π') {
                          action = 'append';
                          value = 'pi';
                        }
                        return (
                          <Flex.Item key={colIdx} basis="25%" mb={1}>
                            <Button
                              fluid
                              textAlign="center"
                              fontSize="18px"
                              height="2.2em"
                              color={
                                btn === 'Eval'
                                  ? 'green'
                                  : btn === 'AC'
                                    ? 'red'
                                    : btn === '⌫'
                                      ? 'orange'
                                      : btn === '∫dx'
                                        ? 'purple'
                                        : 'default'
                              }
                              onClick={() => act(action, { value })}>
                              {btn === '∫dx' ? '∫ f(x) dx' : btn}
                            </Button>
                          </Flex.Item>
                        );
                      })}
                    </Flex>
                  </Flex.Item>
                ))}
              </Flex>
            </Section>
          </Stack.Item>
          {history.length > 0 && (
            <Stack.Item>
              <Section title="History" scrollable>
                <Box maxHeight="60px">
                  {history.map((entry, i) => (
                    <Box key={i} fontSize="12px">
                      {entry}
                    </Box>
                  ))}
                </Box>
              </Section>
            </Stack.Item>
          )}
        </Stack>
      </Window.Content>
    </Window>
  );
};
