# ⏰ Digital Clock & Stopwatch on Nexys 4 DDR FPGA  

## 📝 Overview  
This project implements a **timekeeping system** on the **Nexys 4 DDR FPGA board** using **Verilog HDL**.  
It features two modes:  

1. **Digital Clock** – Displays real-time hours, minutes, and seconds (24-hour format).  
2. **Stopwatch with Timer Feature** – Operates as a stopwatch, automatically stopping at a preset time (10 minutes 16 seconds) and lighting up an LED indicator.  

The design uses the onboard **100 MHz clock**, a clock divider, and multiplexed **7-segment displays** for output.  

---

## ✨ Features  

### 🕒 Digital Clock  
- Counts **HH:MM:SS** in 24-hour format.  
- Seconds and minutes roll over at 60, hours roll over at 24.  
- Uses an **asynchronous reset** to restart from `00:00:00`.  
- Displays time across **6 digits** on the 7-segment display.  

### ⏱ Stopwatch (Timer Mode)  
- Stopwatch runs with `timer_switch` enabled.  
- Automatically **stops at 10:16 (MM:SS)**.  
- **LED (`timer_led`) lights up** when target is reached.  
- Shares the same 7-segment multiplexing display logic.  

---

---

## ⚡ Inputs & Outputs  

### Inputs  
- `clk` → 100 MHz system clock  
- `rst` → Active-low reset  
- `timer_switch` → Mode select (0 = Clock, 1 = Stopwatch/Timer)  

### Outputs  
- `sevseg [6:0]` → 7-segment segment driver (active low)  
- `an [7:0]` → Anode signals for digit multiplexing  
- `timer_led` → Lights up at 10:16 in stopwatch mode  

---

## ⚙️ Working Principle  

1. **Clock Divider**  
   - A 27-bit counter reduces the 100 MHz input clock to 1 Hz.  
   - This drives the time counters.  

2. **Counters**  
   - Digital Clock → increments HH:MM:SS, rolls over correctly.  
   - Stopwatch → increments MM:SS until 10:16, then freezes.  

3. **Display Logic**  
   - Converts each BCD digit to **7-segment encoding**.  
   - Uses digit multiplexing for smooth display.  

---

## 🔢 7-Segment Encoding (Active Low)  

| Digit | Encoding (`sevseg`) |
|-------|----------------------|
| 0     | `0000001` |
| 1     | `1001111` |
| 2     | `0010010` |
| 3     | `0000110` |
| 4     | `1001100` |
| 5     | `0100100` |
| 6     | `0100000` |
| 7     | `0001111` |
| 8     | `0000000` |
| 9     | `0000100` |

---

## 🚀 How to Run  

1. Open **Vivado** and create a new project.  
2. Add the Verilog source files (`top_module.v`, `clock_divider.v`, etc.).  
3. Add the **constraints file (`constraints.xdc`)** for Nexys 4 DDR:  
   - 100 MHz clock pin  
   - Reset push button  
   - Switch for `timer_switch`  
   - LED pin for `timer_led`  
   - Anode + segment pins for 7-segment display  
4. Run: **Synthesis → Implementation → Generate Bitstream**.  
5. Program the FPGA.  
6. Use switches to toggle between **Clock** and **Stopwatch modes**.  

---

## ⚠️ Limitations  
- Digital clock always starts at `00:00:00` after reset.  
- Stopwatch timer target is **hardcoded at 10:16**.  
- No manual time-setting feature.  

---

## 🔮 Future Improvements  
- Add **time adjustment** for clock mode.  
- Stopwatch **start/stop/reset push buttons**.  
- Configurable **timer preset values**.  
- Add **date/day tracking**.  

---

.  

---
  
