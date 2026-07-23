# conferencebadgeR

<p align="center">
  <img src="assets/conferencebadgeR.png" width="600">
</p>

`conferencebadgeR` is a simple R script for generating printable conference name badges from a CSV file.

It creates **10 badges per A4 page** in a 2 × 5 layout. Each badge is **90 × 54 mm**, with no gaps between badges and a removable outer edge around the sheet for trimming with a paper guillotine or slicer.

Each badge can contain:

- first name and surname
- institution
- a custom background/logo image

The output is a print-ready PDF.

---
## TL;DR: Quick start guide
Put `conferencebadgeR.R`, `name_badges.csv`, and `badge_logo.png` in the same folder, then run or source `conferencebadgeR.R`.
`name_badges.csv` must contain columns `first_name`, `last_name`, `institution`; column `pronouns` is optional (set `show_pronouns = FALSE`). Print `name_badges.pdf` and cut. The default output is 10 badges with size 90 × 54 mm.

---

## Badge layout

The script uses an A4 portrait page:

- page size: 210 × 297 mm
- 2 columns
- 5 rows
- badge size: 90 × 54 mm
- 10 badges per page
- no spacing between badges
- 15 mm trimming margin on the left and right
- 13.5 mm trimming margin at the top and bottom

The 2 × 5 badge grid occupies 180 × 270 mm and is centred on the A4 page.

This provides a sacrificial outer edge that can be trimmed away before cutting the individual badges.

## Requirements

The script requires R and the following packages:

```r
install.packages(c(
  "readr",
  "png"
))
```

The `grid` package is included with R.

## Input files

### Attendee list

Create a CSV file called:

```text
name_badges.csv
```

It must contain three columns:

```csv
first_name,last_name,institution
Amina,Okafor,University of Lagos
Mateo,García-Ruiz,Universidad Nacional Autónoma de México
Priya,Natarajan,Indian Institute of Science
```

Names and institutions can contain Unicode characters.

### Badge logo/background

The script expects an image called:

```text
badge_logo.png
```

By default, the image is stretched across the width of each badge.

The background image is drawn across the width of each badge.

For an image that exactly matches the badge dimensions, use an aspect ratio of:

```text
90 : 54
```

or equivalently:

```text
5 : 3
```

For example, an image of `1500 × 900 px` has the correct proportions.

## Repository structure

```text
ConferenceBadgeR/
├── README.md
├── conferencebadgeR.R
├── name_badges.csv
├── badge_logo.png
└── assets/
    └── conferencebadgeR.png
```

## Running the script

From the repository directory, run:

```bash
Rscript conferencebadgeR.R
```

Or press `[Source]` in RStudio after setting the correct working directory.

The script will create:

```text
name_badges.pdf
```

If there are more than 10 attendees, additional pages are created automatically.

## Name formatting

First and last names are combined automatically:

```text
Amina Okafor
```

Long names are wrapped across multiple lines. Hyphenated names can also wrap at the hyphen, for example:

```text
Anastasia
Kowalska-
Wojciechowska
```

Institution names are wrapped separately beneath the attendee name.

## Pronouns

Pronouns can optionally be included on the badges.

Near the top of the script, set `show_pronouns <- TRUE` to include pronouns, or `show_pronouns <- FALSE` to omit them.

When `show_pronouns <- TRUE`, the input CSV must contain a `pronouns` column, for example:

```csv
first_name,last_name,institution,pronouns
Amina,Okafor,University of Lagos,she/her
Mateo,García-Ruiz,Universidad Nacional Autónoma de México,he/him
Alex,Patel,University of Manchester,they/them
Linh,Nguyễn,Vietnam National University,
```

Pronouns are displayed between the attendee's name and institution.

For example:

```text
Amina Okafor
she/her

University of Lagos
```

The `pronouns` field can be left blank for individual attendees. In that case, no pronouns are printed for that person.

When `show_pronouns <- FALSE`, the script ignores pronouns entirely and the CSV does not need to contain a `pronouns` column.

The badge then uses the following layout:

```text
Amina Okafor

University of Lagos
```

## Unicode support

The PDF is generated using `cairo_pdf()` so that names containing accented and non-ASCII characters can be rendered correctly, for example:

```text
Linh Nguyễn
Élodie Moreau
İrem Yılmaz
Łukasz Żółć
```

A suitable Unicode font must be available on the system.

## Printing and cutting

Print the PDF using:

```text
Actual size / 100%
```

Do **not** use options such as:

```text
Fit to page
Shrink to printable area
Scale to fit
```

These will change the physical dimensions of the badges.

After printing:

1. trim 15 mm from the left and right edges
2. trim 13.5 mm from the top and bottom edges
3. cut the remaining sheet into two 90 mm columns
4. cut each column into five 54 mm badges

The script can draw thin cutting guides around each badge to make alignment easier.

Cut with a paper guillotine or print on pre-perforated paper (check the dimensions line up with your paper before printing!)

## Customisation

The main badge dimensions and layout are defined near the top of the script:

```r
page_width <- 210
page_height <- 297

badge_width <- 90
badge_height <- 54

badges_per_row <- 2
badges_per_col <- 5
```

The outer trimming margins are calculated automatically:

```r
grid_width <- badge_width * badges_per_row
grid_height <- badge_height * badges_per_col

margin_x <- (page_width - grid_width) / 2
margin_y <- (page_height - grid_height) / 2
```

With the default dimensions, this gives:

```text
margin_x = 15 mm
margin_y = 13.5 mm
```

Text size and position can be changed in the `grid.text()` calls.

For example:

```r
fontsize = 18
```

controls the name size.

The logo/background dimensions are controlled by:

```r
logo_width_mm <- badge_width
logo_height_mm <- logo_width_mm * dim(logo)[1] / dim(logo)[2]
```

## Example

An example attendee CSV and badge image are included in this repository so that the script can be tested without using real attendee information.

## Why?

Conference badge templates are often tied to proprietary software, commercial label formats, or awkward mail-merge workflows.

This script provides a small reproducible alternative: a CSV goes in, and a correctly sized PDF comes out.
