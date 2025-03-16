# Optimized Prompt for Extracting Baseball Scouting Reports from Text File

**You are an expert in structured data extraction from text files using Python.** I have a `.txt` file containing **100 structured player scouting reports** that need to be accurately converted into a **CSV file**.

## What You Must Do:
1. **Ensure all 100 players are extracted**, handling formatting inconsistencies such as:
   - Players having **multiple positions** (e.g., "SS,3B").
   - Variations in **team names** (e.g., "Boston Red Sox" vs. "BOS").
   - **Scouting reports spanning multiple lines**.
2. **Extract and map fields correctly**, ensuring all data points are captured under these CSV headers:
   - `overall_ranking`
   - `first_name`
   - `last_name`
   - `pos` (position)
   - `team`
   - `height`
   - `weight`
   - `b_t` (bats/throws)
   - `age`
   - `future_value`
   - `risk`
   - `body` (full scouting report, including "The Skinny")
   - **For Pitchers:**
     - `fastball_proj`, `sweeper_proj`, `changeup_proj`, `cutter_proj`, `control_proj`
   - **For Batters:**
     - `hit_proj`, `power_proj`, `run_proj`, `field_proj`, `arm_proj`
3. **Refine parsing logic to correctly segment data**, avoiding:
   - **Regex mismatches** causing missing players.
   - **Errors due to inconsistent spacing or missing fields**.
   - **Extraction failures caused by varied text structures**.
4. **Ensure "The Skinny" text is fully captured in the `body` field**, avoiding previous errors where only partial scouting reports were extracted.
5. **Handle missing or malformed values gracefully**:
   - If a field is missing, assign `None` instead of causing an error.
   - Ensure `BA Grade/Risk` is parsed correctly, handling variations like `65/High` or `60/Extreme`.
   - Ensure height, weight, and age fields are extracted without errors.
6. **Extract and format scouting grades dynamically**, ensuring:
   - **Pitching grades** are captured only for pitchers.
   - **Hitting, fielding, and running grades** are captured only for batters.
   - Grades that don’t exist for a player are left as `None`.
7. **Ensure validation before generating the final CSV**:
   - Confirm there are **exactly 100 players** in the dataset.
   - **Sort the list by `overall_ranking`** before saving.
   - Remove any **duplicate or misformatted entries**.
8. **Save and provide a downloadable CSV file with UTF-8 BOM encoding**.

## Lessons Applied from Previous Attempts:
✅ **Use structured text segmentation**, breaking entries at player ranking numbers (e.g., `1. Roki Sasaki`).  
✅ **Refine regex patterns to dynamically handle missing or optional fields**.  
✅ **Ensure all text variations are handled**, including different scouting report structures.  
✅ **Gracefully handle missing values** without script failures.  
✅ **Extract grades dynamically**, ensuring correct parsing of both pitcher and batter attributes.  
✅ **Correctly capture "The Skinny" text in its entirety into the `body` field**.  

## Final Takeaway:
This optimized approach ensures that **all 100 players are extracted correctly in one attempt**, avoiding unnecessary debugging and reprocessing.
