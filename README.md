# Digital Clock on Nexys 4 DDR FPGA  

## 🕒 Overview  
This project implements a **24-hour digital clock** on the **Nexys 4 DDR FPGA board** using **Verilog HDL**.  
The clock displays **hours, minutes, and seconds (HH:MM:SS)** on the board’s **7-segment display** using multiplexing.  

---

## ✨ Features  
- ✅ Counts **seconds (00–59)**  
- ✅ Counts **minutes (00–59)**  
- ✅ Counts **hours (00–23)**  
- ✅ Uses a **1 Hz clock** derived from the FPGA’s 100 MHz oscillator  
- ✅ Multiplexed **7-segment display driver**  
- ✅ Supports **asynchronous reset**  

---


---

## ⚡ Inputs & Outputs  

### Inputs  
- `clk` : 100 MHz system clock from FPGA  
- `rst` : Active-low reset  

### Outputs  
- `sec_ones [3:0]` → Seconds ones digit  
- `sec_tens [2:0]` → Seconds tens digit  
- `min_ones [3:0]` → Minutes ones digit  
- `min_tens [2:0]` → Minutes tens digit  
- `hr_ones [3:0]` → Hours ones digit  
- `hr_tens [1:0]` → Hours tens digit  
- `sevseg [6:0]` → 7-segment segment driver (active low)  
- `an [7:0]` → 7-segment display enable lines  

---

## ⚙️ Working Principle  

1. **Clock Divider**  
   - The FPGA clock runs at 100 MHz.  
   - A 27-bit counter divides it down to generate a **1 Hz clock**.  
   - This slow clock drives the time counters.  

2. **Counters**  
   - **Seconds**: `00–59`  
   - **Minutes**: `00–59`  
   - **Hours**: `00–23`, then rollover  
   - Each counter cascades into the next.  

3. **Display Logic**  
   - BCD values converted to 7-segment patterns.  
   - Multiplexing logic (`display_count`) cycles through the digits rapidly.  
   - Persistence of vision makes all digits appear simultaneously.  

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
2. Add `digitalclock.v` as the source file.  
3. Add and edit the **constraints file (`.xdc`)** to map:  
   - Clock pin (100 MHz oscillator)  
   - Reset push button  
   - 7-segment display pins (`an`, `sevseg`)  
4. Generate the bitstream and program the Nexys 4 DDR FPGA.  
5. Reset the board → Clock starts from `00:00:00`.  

---

## ⚠️ Limitations  
- Starts always from `00:00:00` (no manual time setting).  
- Works in **24-hour format** only.  
- Accuracy depends on clock divider (slight drift possible).  

---

## 🔮 Future Improvements  
- Add **AM/PM mode** for 12-hour format.  
- Implement **push button time adjustment**.  
- Extend to include **date & day counters**.  
- Use PLL/MMCM for more **accurate clocking**.  
