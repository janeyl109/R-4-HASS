# Global options
options(stringAsFactors = FALSE)
options(scipen = 100)
options(max.print = 100)

library(dplyr)
library(ggplot2)

#numberic project
my_number <- 42
my_name <- "linguistics"
is_true <- TRUE
my_number
my_name
is_true

#suare root
sqrt(144)
#decimal places
round(3.14159, digits = 2)
#counts the characters
nchar("linguistics")
#join strings together
paste("language", "data", "analysis", sep = "-")
#round the square root
round(sqrt(2), digits = 3)
#Arithmetic operators
10 + 3
10 - 3
10 * 3
10 / 3
10 ^ 2
10 %% 3
5 > 3
5 == 5
5 != 3
5 >= 5
TRUE & FALSE  # AND

TRUE | FALSE # OR

!TRUE # NOT

#class
age <- 28.5
class(age)

count <- 42L
class(count)

language <- "English"
class(language)

is_native <- TRUE
class(is_native)

is.numeric(age)

is.character(language)

is.logical(is_native)
#convert between types 

#character to numeric
as.numeric("3.14")
#numberic to character
as.character(42)
#numeric to logical (0 = FALSE, everything else = TRUE)
as.logical(0)
as.logical(1)
as.logical(-99)
as.numeric("hello")

# Vectors
# Numeric vector
word_lengths <- c(3,5,2,8,4,6,1)
# Character vector
languages <- c("English", "German", "Mandarin", "Arabic")
# Logical vector
is_content_word <- c(TRUE, TRUE, FALSE, TRUE, FALSE)

word_lengths * 2

word_lengths > 4

length(word_lengths)

sum(word_lengths)

mean(word_lengths)

sd(word_lengths)

min(word_lengths)

max(word_lengths)

range(word_lengths)
# Create a sequence with :
1:10
# Create a sequence with seq()
seq(from = 0, to = 1, by = 0.25)

seq(from = 1, to = 100, length.out = 5)

# repeat valus with rep()
rep("yes", times = 3)

rep(c("A", "B"), times = 4)

rep(c("A", "B"), each = 4)

#Factors, a type of vector for categoical variables

register <- factor(c("Formal", "Informal", "Formal", "ReadAloud", "Informal"))

register
# unique categories
levels(register)
# number of categories
nlevels(register)
#frequency of each level
table(register)

# Custom level order
register_ordered <- factor(
  c("Formal", "Informal", "Formal", "ReadAloud", "Informal"),
  levels = c("Formal", "ReadAloud", "Informal")
)

levels(register_ordered)


# data frame
speakers <- data.frame(
  ID          = 1:6,
  Name        = c("Alice", "Bob", "Carol", "David", "Eve", "Frank"),
  L1          = c("English", "German", "English", "Mandarin", "English", "Arabic"),
  Age         = c(24, 31, 28, 22, 35, 27),
  Proficiency = factor(c("Advanced", "Intermediate", "Advanced", "Beginner", "Intermediate", "Advanced"),
                      levels = c("Beginner", "Intermediate", "Advanced"))
)

# Inspect data frame
speakers

#number of rows
nrow(speakers)
#number of columns
ncol(speakers)
#rows and columns
dim(speakers)
#column names
names(speakers)
#types and first value
str(speakers)
#first 3 rows
head(speakers, n = 3)
#last 2 rows
tail(speakers, n = 2)
#summary statistics per column
summary(speakers)


#create a list with mixed types
my_list <- list(
  name     = "Study 1",
  n        = 30,
  groups   = c("Control", "Treatment"),
  complete = TRUE
)

#access list elements with $ or [[]]
my_list$name
my_list[["n"]]

#indexing vectors
languages <- c("English", "German", "Mandarin", "Arabic", "French")
languages [1]
languages [4]
languages [c(1, 3)]
languages [2:4]
languages [-2]  #everything except the second
languages [-c(1,5)]

#lexical indexing
word_lengths <- c(3,5,2,8,4,6,1)
word_lengths[word_lengths >4]
word_lengths[word_lengths == min(word_lengths)]

#single cell: row 2, column 3
speakers[2,3]
speakers[1, ]   #entire row 1
speakers[ ,3]
speakers$Age
speakers$L1
speakers[1:3, c("Name", "Age")]

#filter() keeps wors that meet a condition
speakers |>
  dplyr::filter(L1 == "English")
#select() keeps specified columns
speakers |>
  dplyr::select(Name, Age, Proficiency)
#combine both
speakers |>
  dplyr::filter(Age <30) |>
  dplyr::select(Name, L1, Age)
#pipe operator |> passes the result on the left to the function on the right

#read data from CSV
my_data <- read.csv("data/my_file.csv")
my_data <- read.csv(here::here("data", "my_file.csv"))
my_data <- readr::read_csv(here::here("data", "myfile.csv"))
#from Excel
my_data <- readxl::read_excel(here::here("data", "my_file.xlsx"))
#specify a sheet
my_data <- readxl::read_excel(here::here("data", "my_file.xlsx"), sheet = "Sheet 2")

#saving data
write.csv(my_data, here::here("data", "processed_data.csv"), row.names = FALSE)
saveRDS(my_data, here::here("data", "processed_data.rds"))
my_data <- readRDS(here::here("data", "processed_data.rds"))


#manipulating data with dplyr
set.seed(42)
n <- 60

lex_data <-data.frame(
  Participant    = rep(1:20, each = 3),
  Condition      = rep(c("High_Freq", "Low_Freq", "Pseudoword"), times = 20),
  RT_ms          = c(
    rnorm(20, mean = 480, sd = 55),  #high freq: fast
    rnorm(20, mean = 610, sd = 70),  #low freq: slower
    rnorm(20, mean = 730, sd = 80)   #pseudowords: slowest
  ),
  Accurate       = sample(c(TRUE, FALSE), n, replace = TRUE, prob = c(0.9, 0.1))
) |>
  dplyr::mutate(Condition = factor(Condition,
                                   levels = c("High_Freq", "Low_Freq", "Pseudoword")))

#mutate() add or modify columns
lex_data <- lex_data |>
  dplyr::mutate(
    RT_s         = RT_ms / 1000,
    RT_log       = log(RT_ms),
    Fast_respons = RT_ms < 500
  )

head(lex_data)
          
#group_by() and summarise() - Aggregate by Group
lex_data |>
  dplyr::group_by(Condition) |>
  dplyr::summarise(
    n        = n(),
    M_RT     = round(mean(RT_ms), 1),
    SD_RT    = round(sd(RT_ms), 1),
    Accuracy = round(mean(Accurate) *100, 1),
    .groups = "drop"
  ) |>
  flextable::flextable() |>
  flextable::set_table_properties(width = .8, layout = "autofit") |>
  flextable::theme_zebra() |>
  flextable::fontsize(size = 12) |>
  flextable::fontsize(size = 12, part = "header") |>
  flextable::align_text_col(align = "center") |>
  flextable::set_caption(caption = "Reaction times and accuracy by condition in the lexical decision task.") |>
  flextable::border_outer()

#arrange() - sort rows
#sort by RT (ascending)
lex_data |>
  dplyr::arrange(RT_ms) |>
  head(5)
#sort descending
lex_data |>
  dplyr::arrange(desc(RT_ms)) |>
  head(5)

#rename() and relocate()
lex_data |>
  dplyr::rename(ReactionTime = RT_ms, Correct = Accurate) |>
  head(3)

#count()
lex_data |>
  dplyr::count(Condition)

#cross-tabulate condition and accuracy
lex_data |>
  dplyr::count(Condition, Accurate)

#check for missing values
sum(is.na(lex_data$RT_ms))
colSums(is.na(lex_data))
#remove rows with any missing value
lex_data_clean <- lex_data |>
  tidyr:drop_na()

#replace NA with a value
lex_data |>
  dplyr::mutate(RT_ms = ifelse(is.na(RT_ms), mean(RT_ms, na.rm = TRUE), RT_ms))

#visualization with ggplot2
ggplot(data = my_data, aes(x = variable1, y = variable2)) +
  geom_point() +
  theme_bw() +
  labs(title = "My plot", x = "X label", y = "Y label")

ggplot(lex_data, aes(x = RT_ms, fill = Condition)) +
  geom_histogram(bins = 20, color = "white", alpha = 0.7) +
  facet_wrap(~ Condition, ncol = 1) +
  scale_fill_manual(values = c("steelblue", "tomato", "seagreen")) +
  theme_bw() +
  theme(legend.position = "none", panel.grid.minor = element_blank()) +
  labs(title = "Distribution of reaction times by conditon",
       x = "Reaction time (ms)", y = "Count")

#boxplots
ggplot(lex_data, aes(x = Condition, y = RT_ms, fill = Condition)) +
  geom_boxplot(alpha = 0.7, outlier.color = "gray40") +
  stat_summary(fun = mean, geom = "point",
               shape = 18, size = 3, color = "black") +
  scale_fill_manual(values = c("steelblue", "tomato", "seagreen")) +
  theme_bw() +
  theme(legend.position = "none", panel.grid.minor = element_blank()) +
  labs(title = "Reaction times by condition",
       subtitle = "Diamond = group mean; box = median and IQR",
       x = "Condition", y = "Reaction time (ms)")
  
#Bar charts
lex_data |>
  dplyr::group_by(Condition) |>
  dplyr::summarise(M_RT = mean(RT_ms),
                   SE   = sd(RT_ms) / sqrt(n()),
                   .groups = "drop") |>
  ggplot(aes(x = Condition, y = M_RT, fill = Condition)) +
  geom_col(alpha = 0.8, width = 0.6) +
  geom_errorbar(aes(ymin = M_RT - SE, ymax = M_RT + SE),
                width = 0.2, linewidth = 0.8) +
  scale_fill_manual(values = c("steelblue", "tomato", "seagreen")) +
  theme_bw() +
  theme(legend.position = "none", panel.grid.minor = element_blank()) +
  labs(title = "Mean reaction time by condition",
       subtitle = "Error bars = ±1 SE",
       x = "Condition", y = "Mean RT (ms)")

#scatter plots
ggplot(lex_data, aes(x = Participant, y = RT_ms, color = Condition)) +
  geom_point(alpha = 0.7, size = 2) +
  scale_color_manual(values = c("steelblue", "tomato", "seagreen")) +
  theme_bw()
  theme(paniel.grid.minor = element_blank()) +
    labs(title = "Individual RT observations by participant and condition",
         x = "Participant ID", y = "Reaction time (ms)",
         color = "Condition")

#saving plots
  ggsave(
    filename = here::here("..", "images", "my_plot.png"),
    width   = 8,
    height  = 5,
    dpi     = 300
  )

  my_plot <- ggplot(lex_data, aes(x = RT_ms, fill = Condition)) +
  geom_histogram(bins = 20, color = "white", alpha = 0.7) +
  facet_wrap(~ Condition, ncol = 1) +
  scale_fill_manual(values = c("steelblue", "tomato", "seagreen")) +
  theme_bw() +
  theme(legend.position = "none", panel.grid.minor = element_blank()) +
  labs(title = "Distribution of reaction times by conditon",
       x = "Reaction time (ms)", y = "Count")

  ggsave(
    plot     = my_plot,
    filename = here::here("..", "images", "histogram.pdf"),
    width    = 6,
    height   = 4
  )
  
  #theme_bw() for a clean white background
  #theme(paniel.grid.minor = element_blank()) remove minor gridlines
  #scale_color_manual() / scale_fill_manuel() to control colors
  #facet_wrap(~ variable) to create small multiples
  #labs() to set title, subtitle and axis labels
  # + coord_flip() swap x and y axes

  
#helpe
?mean
help(mean)

??regression
apropos("filter ")

args(ggplot)

example(boxplot)
"boxplot"

#Vignettes 
vignette(package = "dplyr")

vignette("dplyr")
vignette("ggplot2-specs")

#list
ls()

# Remove everything (use with caution!)  
# rm(list = ls())  

getwd()
setwd("/Users/janey/Documents/R4SHH")
getwd()



  
  
  








