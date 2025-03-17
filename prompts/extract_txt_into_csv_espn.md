# **Optimized Prompt for Extracting ESPN McDaniel Top 100 Baseball Scouting Reports from Text File**

**You are an expert in structured data extraction from text files using Python.** I have a `.txt` file containing **100 structured player scouting reports** that need to be accurately converted into a **CSV file**.

## **Extraction Requirements:**
1. **Extract all 100 players**, handling formatting inconsistencies such as:
   - Players having **multiple positions** (e.g., "SS,3B").
   - Variations in **team names** (e.g., "Boston Red Sox" → "BOS").
   - **Scouting reports spanning multiple lines**.

2. **Extract and map fields correctly**, ensuring all data points are captured under these CSV headers:
   - `overall_ranking`
   - `first_name`
   - `last_name`
   - `pos` (position)
   - `team` (convert full team name to abbreviation)
   - `b_t` (bats/throws)
   - `future_value` (extracted from the tier heading before player entries)
   - `body` (scouting report text)
   - **For Pitchers:**
     - `fastball_proj`, `sweeper_proj`, `changeup_proj`, `cutter_proj`, `control_proj`
   - **For Batters:**
     - `hit_proj`, `power_proj`, `run_proj`, `field_proj`, `arm_proj`

3. **Ensure proper segmentation and data extraction**:
   - Use **structured text segmentation** by splitting player entries at ranking numbers (e.g., `"1. Roki Sasaki"`).
   - **Extract player names, positions, and teams from the first lines** of each entry.
   - **Match team names to their abbreviations** using a predefined mapping (e.g., `"Dodgers"` → `"LAD"`).
   - Ensure **scouting report extraction follows correct formatting**:
     - **For players 1-22**, the body starts after `"Reminds me of:"`.
     - **For players 23+**, the body starts after `"Type:"`.

4. **Ensure every player has a correct team assignment**:
   - Extract the **team name** directly from the first line of each player's entry.
   - Convert **full team names** to **MLB team abbreviations** (e.g., `"Red Sox"` → `"BOS"`).
   - Ensure **no missing team values** by cross-referencing extracted text.

5. **Handle missing or malformed values gracefully**:
   - If a field is missing, assign `None` instead of causing an error.
   - Ensure extracted data is clean, free from artifacts, and formatted correctly.

6. **Validate the extracted data before finalizing the CSV file**:
   - Confirm there are **exactly 100 players** in the dataset.
   - **Sort by `overall_ranking`** before saving.
   - Ensure **all players have valid team values** (no missing team assignments).
   - Remove any **duplicate or misformatted entries**.

7. **Save the final dataset in a CSV file with UTF-8 BOM encoding**:
   - This prevents **Excel from displaying incorrect characters** (e.g., `‚Äô` instead of an apostrophe).
   - Provide a **download link** for the CSV file.

---

## **Lessons Applied from Previous Attempts:**
✅ **Correctly extract structured ranking entries** (e.g., `"1. Roki Sasaki, RHP, Dodgers"`).  
✅ **Ensure player names, positions, and teams are parsed separately and accurately**.  
✅ **Map full team names to abbreviations dynamically to avoid missing values**.  
✅ **Extract scouting reports fully by capturing text after `"Reminds me of:"` (players 1-22) and `"Type:"` (players 23-100)**.  
✅ **Refine regex patterns to dynamically handle missing or optional fields**.  
✅ **Gracefully handle missing values**, ensuring no script failures.  
✅ **Save CSV with UTF-8 BOM encoding** to avoid Excel formatting issues.  

---

## **Final Takeaway:**
This **optimized approach** ensures that **all 100 players are extracted correctly in one attempt**, **without requiring troubleshooting or reprocessing**. The **team mapping is fully automated**, and all required fields are **accurately extracted**.  

This setup guarantees a **flawless, structured, and efficient extraction process** for **ESPN McDaniel Top 100 baseball scouting reports**.
