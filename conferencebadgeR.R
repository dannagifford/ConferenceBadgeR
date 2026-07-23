library(readr)
library(grid)
library(png)

# Files
csv_file <- "name_badges.csv"
logo_file <- "badge_logo.png"
output_file <- "name_badges.pdf"

# Read data
people <- read_csv(
  csv_file,
  show_col_types = FALSE
)

# Check columns
required_cols <- c(
  "first_name",
  "last_name",
  "institution"
)

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

# A4 page geometry in mm
page_width <- 210
page_height <- 297

# Badge dimensions
badge_width <- 90
badge_height <- 54

badges_per_row <- 2
badges_per_col <- 5
badges_per_page <- badges_per_row * badges_per_col

# Total badge grid
grid_width <- badge_width * badges_per_row
grid_height <- badge_height * badges_per_col

# Equal trimming margin around the badge grid
margin_x <- (page_width - grid_width) / 2
margin_y <- (page_height - grid_height) / 2

# Logo size
logo_width_mm <- badge_width
logo_height_mm <- logo_width_mm * dim(logo)[1] / dim(logo)[2]

# Split attendees into pages
pages <- split(
  people,
  ceiling(seq_len(nrow(people)) / badges_per_page)
)

# Create PDF using Cairo for Unicode support
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
    
    col <- ifelse(
      i %% badges_per_row == 0,
      badges_per_row,
      i %% badges_per_row
    )
    
    # Bottom-left corner of badge
    x_left <- margin_x +
      (col - 1) * badge_width
    
    y_bottom <- page_height -
      margin_y -
      row * badge_height
    
    # Badge centre
    centre_x <- x_left + badge_width / 2
    centre_y <- y_bottom + badge_height / 2
    
    # Badge background/logo
    grid.raster(
      logo,
      x = unit(centre_x, "mm"),
      y = unit(centre_y, "mm"),
      width = unit(logo_width_mm, "mm"),
      height = unit(logo_height_mm, "mm"),
      interpolate = TRUE
    )
    
    # Name
    name_text <- paste(
      page$first_name[i],
      page$last_name[i]
    )
    
    # Allow wrapping after hyphens
    name_text <- gsub(
      "-",
      "- ",
      name_text
    )
    
    name_text <- paste(
      strwrap(
        name_text,
        width = 18
      ),
      collapse = "\n"
    )
    
    name_text <- gsub(
      "- ",
      "-",
      name_text
    )
    
    grid.text(
      label = name_text,
      x = unit(centre_x + 10, "mm"),
      y = unit(centre_y + 5, "mm"),
      gp = gpar(
        fontsize = 18,
        fontface = "bold",
        lineheight = 0.95
      )
    )
    
    # Institution
    institution_text <- paste(
      strwrap(
        as.character(page$institution[i]),
        width = 26
      ),
      collapse = "\n"
    )
    
    grid.text(
      label = institution_text,
      x = unit(centre_x + 10, "mm"),
      y = unit(centre_y - 10, "mm"),
      gp = gpar(
        fontsize = 12,
        lineheight = 1
      )
    )
    
    # Thin cutting guide around each badge
    grid.rect(
      x = unit(x_left, "mm"),
      y = unit(y_bottom, "mm"),
      width = unit(badge_width, "mm"),
      height = unit(badge_height, "mm"),
      just = c("left", "bottom"),
      gp = gpar(
        fill = NA,
        col = NA, # "grey95",
        lwd = 0.4
      )
    )
  }
  
  # Outer trimming rectangle
  grid.rect(
    x = unit(margin_x, "mm"),
    y = unit(margin_y, "mm"),
    width = unit(grid_width, "mm"),
    height = unit(grid_height, "mm"),
    just = c("left", "bottom"),
    gp = gpar(
      fill = NA,
      col = NA, # "grey95",
      lwd = 0.6
    )
  )
}

dev.off()