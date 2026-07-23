# conferencebadgeR

<p align="center">
  <img src="assets/badge_logo.png" width="600">
</p>

`conferencebadgeR` is a simple R script for generating printable conference name badges from a CSV file.

It creates 12 badges per A4 page in a 2 × 6 layout, with no gaps between badges, so they can be cut efficiently using a paper guillotine or slicer.

Each badge can contain:

- first name and surname
- institution
- a custom background/logo image

The output is a print-ready PDF.

## Badge layout

The script uses the full dimensions of an A4 page:

- page size: 210 × 297 mm
- 2 columns
- 6 rows
- badge size: 105 × 49.5 mm
- 12 badges per page
- no spacing between badges

This means the badges can be separated with one vertical cut and five horizontal cuts.

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
assets/badge_logo.png
```

By default, the image is stretched across the width of each badge.

For a background image that exactly matches the badge dimensions, use an aspect ratio of:

```text
105 : 49.5
```

or equivalently:

```text
70 : 33
```

For example, an image of `2100 × 990 px` has the correct proportions.

## Repository structure

```text
conferencebadgeR/
├── README.md
├── make_badges.R
├── name_badges.csv
└── assets/
    └── badge_logo.png
```

## Running the script

From the repository directory, run:

```bash
Rscript make_badges.R
```

The script will create:

```text
name_badges.pdf
```

If there are more than 12 attendees, additional pages are created automatically.

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

## Unicode support

The PDF is generated using `cairo_pdf()` so that names containing accented and non-ASCII characters can be rendered correctly, for example:

```text
Linh Nguyễn
Élodie Moreau
İrem Yılmaz
Łukasz Żółć
```

A suitable Unicode font must be available on the system.

## Printing

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

Some printers cannot print to the very edge of A4 paper. This does not change the positions of the internal cuts, but parts of a full-bleed background close to the outer edge may not print.

## Customisation

The main badge dimensions and text positions are defined near the top of the script:

```r
page_width <- 210
page_height <- 297

badge_width <- 105
badge_height <- 49.5

badges_per_row <- 2
badges_per_col <- 6
```

Text size and position can be changed in the `grid.text()` calls.

For example:

```r
fontsize = 18
```

controls the name size.

The logo/background dimensions are controlled by:

```r
logo_width_mm <- 105
logo_height_mm <- logo_width_mm * dim(logo)[1] / dim(logo)[2]
```

## Example

An example attendee CSV and badge image are included in this repository so that the script can be tested without using real attendee information.

## Why?

Conference badge templates are often tied to proprietary software, commercial label formats, or awkward mail-merge workflows.

This script provides a small reproducible alternative: a CSV goes in, and a correctly sized PDF comes out.

## Licence

MIT
