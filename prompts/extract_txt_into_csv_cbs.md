# **Optimized Prompt for Extracting CBS Top 100 Baseball Prospects from Text File**

**You are an expert in structured data extraction from text files using Python.** I have a `.txt` file containing **100 structured player scouting reports** that need to be accurately converted into a **CSV file**.

## **Extraction Requirements:**
1. **Ensure all 100 players are extracted**, handling formatting inconsistencies such as:
   - Players having **multiple positions** (e.g., "SS,3B").
   - Variations in **team names** (e.g., "Red Sox" → "BOS").
   - **Scouting reports spanning multiple lines**.

2. **Extract and map fields correctly**, ensuring all data points are captured under these CSV headers:
   - `overall_ranking`
   - `first_name`
   - `last_name`
   - `pos` (position)
   - `team` (use **abbreviations** from full team names)
   - `body` (full scouting report text starting after **"Scott's 2025 Fantasy impact:"**)

3. **Ensure proper segmentation and data extraction**:
   - Use **structured text segmentation** by splitting player entries at ranking numbers (e.g., `"1. Roki Sasaki"`).
   - **Extract player names, positions, and teams from the first lines** of each entry.
   - **Match team names to their abbreviations** using a predefined mapping (e.g., `"Dodgers"` → `"LAD"`).
   - Ensure **scouting report extraction starts at** `"Scott's 2025 Fantasy impact:"` **to avoid missing text**.

4. **Ensure every player has a correct team assignment**:
   - Extract the **team name** directly from the first lines of each player's entry.
   - Map **full team names** to **MLB team abbreviations** (e.g., `"Red Sox"` → `"BOS"`).
   - Ensure **no missing team values** by cross-referencing the extracted text.

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
✅ **Correctly extract structured ranking entries** (e.g., `"1. Roki Sasaki, SP, Dodgers"`).  
✅ **Ensure player names, positions, and teams are parsed separately and accurately**.  
✅ **Map full team names to abbreviations dynamically to avoid missing values**.  
✅ **Extract scouting reports fully by capturing text after `"Scott's 2025 Fantasy impact:"`**.  
✅ **Refine regex patterns to dynamically handle missing or optional fields**.  
✅ **Gracefully handle missing values**, ensuring no script failures.  
✅ **Save CSV with UTF-8 BOM encoding** to avoid Excel formatting issues.  

---

## **Final Takeaway:**
This **optimized approach** ensures that **all 100 players are extracted correctly in one attempt**, **without requiring troubleshooting or reprocessing**. The **team mapping is fully automated**, and all required fields are accurately extracted.  

This setup guarantees a **flawless, structured, and efficient extraction process** for **CBS Top 100 baseball scouting reports**.
