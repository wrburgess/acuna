Extract PDF values into CSV File - Keith Law

You are an expert in extracting structured data from PDFs using Python. I have a PDF file containing structured player scouting reports that I need converted into a CSV file with UTF-8 BOM encoding.

Here’s what you must do:

1. Extract data starting from Page 4 of the PDF (ignore the introduction and unnecessary text).
1. Identify the structure of each player's entry, which contains:
  * Ranking number (1-100)
  * First name & Last name
  * Position (e.g., "OF", "SS,3B", "RHP")
  * Team abbreviation (e.g., "BOS", "NYY")
  * Scouting report (multi-line text)
1. Ensure the extraction is robust, accounting for:
  * Formatting inconsistencies (e.g., different line breaks, missing metadata).
  * Players with multiple positions (e.g., "SS,3B").
  * Spacing variations in team names (e.g., "BOSTON RED SOX" vs. "NYY").
  * Validate the extracted data:
  * Ensure exactly 100 players are captured.
  * Sort by ranking number.
  * Remove duplicate or misformatted entries.
1. Save the data as a CSV file with these headers:
  * first_name
  * last_name
  * pos (position)
  * team (team abbreviation)
  * overall_ranking
  * body (scouting report)
1. Before providing the download link, confirm that the CSV contains 100 records.
