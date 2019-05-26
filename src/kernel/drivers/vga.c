#include "vga.h"
#include "ports.h"

int print_char(char, int, char);
void set_cursor(short);
int get_cursor();
int get_position(int, int);
int get_position_x(int);
int get_position_y(int);

void print(char *message) {
    int position = get_cursor();
    int x = get_position_x(position);
    int y = get_position_y(position);
    print_at(message, x, y);
}

void print_at(char *message, int x, int y) {
    int position = get_position(x, y);
    int i = 0;
    while (message[i] != 0) {
        position = print_char(message[i++], position, 0x0f);
    }
}

int print_char(char character, int position, char attribute) {
    unsigned char *videomemory = (unsigned char *)VIDEO_MEMORY;
    videomemory[position * 2] = character;
    videomemory[position * 2 + 1] = attribute;
    position++;
    set_cursor(position);
    return position;
}

void clear_screen() {
    unsigned char *videomemory = (unsigned char *)VIDEO_MEMORY;
    for (int position = 0; position < WIDTH * HEIGHT; position++) {
        videomemory[position * 2] = ' ';
        videomemory[position * 2 + 1] = 0x0f;
    }
    set_cursor(0);
}

void set_cursor(short position) {
    port_byte_out(SCREEN_CTRL_PORT, 14);
    port_byte_out(SCREEN_DATA_PORT, (position >> 8));
    port_byte_out(SCREEN_CTRL_PORT, 15);
    port_byte_out(SCREEN_DATA_PORT, (position & 0xff));
}

int get_cursor() {
    port_byte_out(SCREEN_CTRL_PORT, 14);
    int position = port_byte_in(SCREEN_DATA_PORT) << 8;
    port_byte_out(SCREEN_CTRL_PORT, 15);
    position += port_byte_in(SCREEN_DATA_PORT);
    return position;
}

int get_position(int x, int y) {
    return y * WIDTH + x;
}

int get_position_x(int position) {
    return position * WIDTH;
}

int get_position_y(int position) {
    return position - position * WIDTH;
}