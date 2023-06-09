#include <stdint.h>
#define SW 0x01000000
#define LED 0x02000000

int main()
{
    uint32_t *sw_addr = (uint32_t *)SW;
    uint32_t *led_addr = (uint32_t *)LED;
    const uint32_t v = 5;
    while (1)
    {
        while (*sw_addr)
        {
            if (*sw_addr > v)
                *led_addr = *sw_addr + (v >> 1);
            else
                *led_addr = ((*sw_addr) >> 1) + v;
        }
    }
    return 0;
}