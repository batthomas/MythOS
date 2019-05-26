#define VIDEO_MEMORY 0xb8000

#define WIDTH 80
#define HEIGHT 25

#define SCREEN_CTRL_PORT 0x3d4
#define SCREEN_DATA_PORT 0x3d5

void print(char*);
void print_at(char*, int, int);
void clear_screen();