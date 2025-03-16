# **Optimized Prompt for Extracting Baseball Scouting Reports from Text File (ESPN McDaniel Top 100)**

**You are an expert in structured data extraction from text files using Python.** I have a `.txt` file containing **100 structured player scouting reports** that need to be accurately converted into a **CSV file**.

## **What You Must Do:**
1. **Extract all 100 players**, handling formatting inconsistencies such as:
   - Players having **multiple positions** (e.g., "SS,3B").
   - Variations in **team names** (e.g., "Boston Red Sox" vs. "BOS").
   - **Scouting reports spanning multiple lines**.

2. **Extract and map fields correctly**, ensuring all data points are captured under these CSV headers:
   - `overall_ranking`
   - `first_name`
   - `last_name`
   - `pos` (position)
   - `team`
   - `b_t` (bats/throws)
   - `future_value` (extracted from the tier heading before player entries)
   - `body` (full scouting report text starting after **"Type:"**)
   - **For Pitchers:**
     - `fastball_proj`, `sweeper_proj`, `changeup_proj`, `cutter_proj`, `control_proj`
   - **For Batters:**
     - `hit_proj`, `power_proj`, `run_proj`, `field_proj`, `arm_proj`

3. **Ensure proper segmentation and extraction**:
   - Use **structured text segmentation** by splitting player entries at ranking numbers (e.g., `"1. Roki Sasaki"`).
   - Ensure **scouting report extraction starts at** `"Type:"` **to avoid missing body text**.
   - Capture **all future value (FV) tiers** dynamically, assigning the correct FV to each player.

4. **Handle missing or malformed values gracefully**:
   - If a field is missing, assign `None` instead of causing an error.
   - Ensure correct parsing of **batting and throwing hands (`B-T`)**.
   - Ensure scouting grades are extracted dynamically, supporting both **pitchers and batters**.

5. **Ensure data validation before finalizing the CSV file**:
   - Confirm there are **exactly 100 players** in the dataset.
   - **Sort by `overall_ranking`** before saving.
   - Remove any **duplicate or misformatted entries**.

6. **Save the final dataset in a CSV file with UTF-8 BOM encoding**:
   - This prevents **Excel from displaying incorrect characters** (e.g., `‚Äô` instead of an apostrophe).
   - Provide a **download link** for the CSV file.

---

## **Lessons Applied from Previous Attempts:**
✅ **Start extraction from structured ranking entries (e.g., `1. Player Name`)** for **accurate segmentation**.  
✅ **Extract scouting reports only after `"Type:"`** to ensure full capture of player analysis.  
✅ **Ensure dynamic handling of scouting grades**, distinguishing **pitchers from batters** correctly.  
✅ **Refine regex patterns to dynamically handle missing or optional fields**.  
✅ **Gracefully handle missing values**, ensuring no script failures.  
✅ **Ensure `future_value` is assigned from the correct section heading** before each player entry.  
✅ **Save CSV with UTF-8 BOM encoding** to avoid Excel formatting issues.

---

## **Final Takeaway**
This optimized approach ensures that **all 100 players are extracted correctly in one attempt**, **without requiring troubleshooting or reprocessing**. This approach guarantees an **accurate, structured, and efficient extraction process** for **baseball scouting reports**.
