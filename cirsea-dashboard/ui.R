### UI PAGE

#........................dashboardHeader.........................
header <- dashboardHeader(

  
  # title ---
  title = "CIRSEA Group Project",
  titleWidth = 250
  
  
)

#........................dashboardSidebar........................
sidebar <- dashboardSidebar(
  
  # sidebar ---
  sidebarMenu(
    
    menuItem(text = "About", tabName = "about", icon = icon("star")), #tabName is our id
    menuItem(text = "IUU Tool", tabName = "tool", icon = icon("gear")),
    menuItem(text = "IUU Types", tabName = "iuu_types", icon = icon("fish")),
    menuItem(text = "Monitoring Strategies", tabName = "monitoring_strategies", icon = icon("magnifying-glass"))
    
  ) # END sidebarMenu
  
  
)

#..........................dashboardBody.........................
body <- dashboardBody(
  
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "styles.css"),
  ),

  # set theme later
  # fresh::use_theme("something.css"),

  # tabItems ----
  tabItems(

    tabItem(tabName = "about",

            # left-hand column ----
            column(width = 6,

                   # background info box ---
                   box(width = NULL,

                       title = tagList(icon("fish"),
                                       strong("About the project")),
                       includeMarkdown("text/about.md"),
                       tags$img(src = "cirsea_2.webp",
                                alt = "Logo image",
                                style = "max-width: 100%;") # often will just need to look up how to write the css
                       

                   ) #END background box # takes on width of the column when set to null

            ), # END column


            # right-hand column ---
            column(width = 6,

                   # first fluid row ----
                   fluidRow(

                     # citation box ----
                     box(width = NULL,

                         title = tagList(icon("book"),
                                         strong("Methodology")),
                         includeMarkdown("text/methodology.md")

                     ) # end citation box


                   ) # END first fluidRow


            ) # END right hand column


    ), # END about tabItem

    # dashboard tabItem
    tabItem(tabName = "tool",

            # fluidRow ---
            fluidRow(

              # input box ---
              box(width = 4,

                  title = tags$strong("IUU type and monitoring criteria:"),

                  # IUU Type pickerinput ----
                  pickerInput(inputId = 'iuu_type_input',
                              label = 'Step 1: Select IUU type(s):',
                              choices = unique(iuu_type),
                              selected = unique(iuu_type)[1],
                              options = pickerOptions(actionsBox = TRUE),
                              multiple = FALSE),

                  # section checkboxGroupButtons ----
                  radioGroupButtons(inputId = 'range_input',
                                       label = 'Step 2: Select your monitoring range:',
                                       choices = c("Local", "Regional", "High Seas"),
                                       selected = NULL,
                                       individual = TRUE, justified = TRUE, size = 'sm',
                                       checkIcon = list(yes = icon("check"))
                                       
                  ),

                  # section checkboxGroupButtons
                  checkboxGroupButtons(inputId = 'cost_input',
                                       label = 'Filter by cost preference(s):',
                                       choices = c("$", "$$", "$$$"),
                                       selected = NULL,
                                       individual = FALSE, justified = TRUE, size = 'sm',
                                       checkIcon = list(yes = icon("check"))
                                       
                  ),
                  
                  # section checkboxGroupInput
                  checkboxGroupInput(inputId = "data_type_input",
                                     label = 'Filter by data interest(s):',
                                     choices = c("Eye-witness", "Image", "Location", "Video"),
                                     selected = NULL)

              ), # END input box


              # tool box ---
              box(width = 8,

                  title = strong("Recommended Monitoring Strategies"),

                  # data table output ---
                  dataTableOutput(outputId = "iuu_table_output") %>%
                    withSpinner(color = "skyblue", type = 1)
                  
                 
                  
                
              ), # END tool box
              
              # descriptions box
              box(width = 8,
              title = strong("Descriptions"),
              uiOutput(outputId = "text_output")
              ) # end descriptions box
              
              


            ) # END fluidRow

    ) # END dashboard tabItem


  ) #END tabItems

)



#..................combine all in dashboardPage..................
dashboardPage(header, sidebar, body)