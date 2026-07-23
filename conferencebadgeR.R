library(readr)
library(grid)
library(png)

# Files
csv_file <- "name_badges.csv"
logo_file <- "badge_logo.png"
output_file <- "name_badges.pdf"

# Read data
people <- read_csv(csv_file, show_col_types = FALSE)

# Check columns
required_cols <- c("first_name", "last_name", "institution")

if (!all(required_cols %in% names(people))) {
  stop(
    "CSV must contain these columns: ",
    paste(required_cols, collapse = ", ")
  )
}

if (nrow(people) == 0) {
  stop("The CSV has no rows.")
}

# Read logo
logo <- readPNG(logo_file)

# Badge/page geometry in mm
page_width <- 210
page_height <- 297
badge_width <- 105
badge_height <- 49.5
badges_per_row <- 2
badges_per_col <- 6
badges_per_page <- badges_per_row * badges_per_col

# Logo size
logo_width_mm <- 105
logo_height_mm <- logo_width_mm * dim(logo)[1] / dim(logo)[2]

# Split into pages of 12 badges
pages <- split(
  people,
  ceiling(seq_len(nrow(people)) / badges_per_page)
)

# Open PDF
cairo_pdf(
  output_file,
  width = page_width / 25.4,
  height = page_height / 25.4,
  onefile = TRUE,
  family = "sans"
)

for (page in pages) {
  
  grid.newpage()
  
  for (i in seq_len(nrow(page))) {
    
    # Work out row and column
    row <- ceiling(i / badges_per_row)
    col <- ifelse(i %% badges_per_row == 0, badges_per_row, i %% badges_per_row)
    
    # Bottom-left corner of current badge
    x_left <- (col - 1) * badge_width
    y_bottom <- page_height - row * badge_height
    
    # Badge centre
    centre_x <- x_left + badge_width / 2
    centre_y <- y_bottom + badge_height / 2
    
    # Badge border
    grid.rect(
      x = unit(x_left, "mm"),
      y = unit(y_bottom, "mm"),
      width = unit(badge_width, "mm"),
      height = unit(badge_height, "mm"),
      just = c("left", "bottom"),
      gp = gpar(
        fill = NA,
        col = NA,  # black if you want a border
        lwd = 0.5
      )
    )
    
    # Logo
    grid.raster(
      logo,
      x = unit(centre_x, "mm"),
      y = unit(centre_y + 0, "mm"),
      width = unit(logo_width_mm, "mm"),
      height = unit(logo_height_mm, "mm"),
      interpolate = TRUE
    )
    
    # Name
    name_text <- paste(
      page$first_name[i],
      page$last_name[i]
    )
    
    name_text <- paste(
      strwrap(name_text, width = 20),
      collapse = "\n"
    )
    
    grid.text(
      label = name_text,
      x = unit(centre_x + 12, "mm"),
      y = unit(centre_y + 5, "mm"),
      gp = gpar(
        fontsize = 16,
        fontface = "bold",
        lineheight = 0.95
      )
    )
    
    # Institution
    institution_text <- paste(
      strwrap(as.character(page$institution[i]), width = 28),
      collapse = "\n"
    )
    
    grid.text(
      label = institution_text,
      x = unit(centre_x + 12, "mm"),
      y = unit(centre_y - 10, "mm"),
      gp = gpar(
        fontsize = 12,
        lineheight = 1
      )
    )
  }
}

dev.off()