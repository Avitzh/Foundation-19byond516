import { useBackend } from '../../backend';
import { Box, Button, Section, Stack } from '../../components';
import { Window } from '../../layouts';

type FacialHairPickerData = {
  styles: { name: string; rsc_key: string }[];
  selected: string;
};

export const FacialHairPicker = (props, context) => {
  const { act, data } = useBackend<FacialHairPickerData>(context);
  const { styles, selected } = data;

  return (
    <Window width={450} height={550}>
      <Window.Content scrollable>
        <Section title="Выберите стиль растительности на лице">
          <Stack wrap>
            {styles.map((style) => (
              <Stack.Item key={style.name}>
                <Button
                  selected={style.name === selected}
                  onClick={() => act('select', { style: style.name })}
                  tooltip={style.name}
                  color="transparent"
                  style={{
                    backgroundColor:
                      style.name === selected
                        ? 'rgba(0, 140, 60, 0.35)'
                        : 'rgba(255, 255, 255, 0.10)',
                    padding: '4px',
                    borderRadius: '6px',
                  }}>
                  <Box
                    width="64px"
                    height="64px"
                    style={{
                      backgroundColor: 'rgba(255, 255, 255, 0.14)',
                      boxShadow:
                        'inset 0 0 0 1px rgba(255, 255, 255, 0.18), 0 1px 2px rgba(0, 0, 0, 0.35)',
                      borderRadius: '4px',
                    }}>
                    <Box
                      as="img"
                      src={style.rsc_key}
                      width="64px"
                      height="64px"
                      style={{
                        display: 'block',
                        imageRendering: 'pixelated',
                        objectFit: 'contain',
                        filter:
                          'drop-shadow(0 0 1px rgba(255, 255, 255, 0.65)) drop-shadow(0 0 2px rgba(0, 0, 0, 0.55))',
                      }}
                    />
                  </Box>
                </Button>
              </Stack.Item>
            ))}
          </Stack>
        </Section>
      </Window.Content>
    </Window>
  );
};

