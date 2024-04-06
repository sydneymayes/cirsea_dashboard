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

    # tool tabItem
    tabItem(tabName = "tool",

            # fluidRow ---
            fluidRow(

              # input box ---
              box(width = 4,

                  title = tags$strong("IUU type and monitoring criteria:"),

                  # IUU Type pickerinput ----
                  pickerInput(inputId = 'iuu_type_input',
                              label = 'Step 1: Select IUU type:',
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

              ), #end first input box
              
              # output box for temporary MS -- remove later
                     
              box(width = 8,

                  title = strong("Recommended Monitoring Strategies"),

                  # data table output ---
                  dataTableOutput(outputId = "iuu_table_output") %>%
                    withSpinner(color = "skyblue", type = 1)


                     ), # END input box for satellites
              
              # descriptions box
              box(width = 8,
                  title = strong("Possible Monitoring Strategies"),
                  uiOutput(outputId = "text_output")
              ) # end descriptions box
              ), # End fluidRow
              
             
            # fluidRow 2 ---
            fluidRow(
              
              box(width = 4,
                  
                  title = tags$strong("Satellites"),
                  
                  # IUU Type pickerinput ----
                  pickerInput(inputId = 'iuu_type_satellites_input',
                              label = 'Select IUU type:',
                              choices = unique(iuu_type),
                              selected = unique(iuu_type)[1],
                              options = pickerOptions(actionsBox = TRUE),
                              multiple = FALSE),
                  
                  
                          
                  # Satellite Type
                  pickerInput(
                    inputId = "satellite_type_input",
                    label = "Satellite Type", 
                    choices = c("EO", "SAR", "SAR (High Res)", "RF"),
                    multiple = TRUE,
                  ),
                  
                  # Free or not
                  materialSwitch(
                    inputId = "satellite_cost_input",
                    label = "Free Data", 
                    value = FALSE,
                    status = "primary"
                  ),
                  
                  materialSwitch(
                    inputId = "satellite_delivery_input",
                    label = "Near Real-time Delivery", 
                    value = FALSE,
                    status = "success"
                  )
              ), # end satellite input box
              
              # satellite descriptions box
              box(width = 8,
                  title = strong("Satellite Options"),
                  uiOutput(outputId = "satellite_output")
              ) # end satellite descriptions box
                
              ), # END second fluid row


   

    ), # END tool tabItem
    
    
    # IUU Types tab item
    tabItem(tabName = "iuu_types",
            
            # how to use
            fluidRow(
              div("Click on an IUU Type to learn more.", style = "margin-bottom: 20px;")
            ),
            
            # IUU type text fluidRow ----
            fluidRow(
              useShinyjs(),  # Initialize shinyjs
              # # Testing out using tags to create a button with HTML content, including a line break
              # tags$button(id = "Vessel with false flag",
              #             style = "padding: 100px; font-size: 18px;",
              #             type = "button",
              #             class = "btn btn-default action-button",
              #             icon("flag"), "Vessel with", br(), "false flag"),
              # tags$button(id = "Underreporting of fishing effort",
              #             style = "padding: 100px; font-size: 18px;",
              #             type = "button",
              #             class = "btn btn-default action-button",
              #             icon("dumbbell"), "Underreporting of", br(), "fishing effort"),
              # 
              
              

              column(width = 12,
                     # Define buttons for IUU types dynamically or statically here
                     actionButton("Dark Vessels (not broadcasting location via VMS/AIS)", "Dark Vessels", icon = icon("moon"), style='padding:50px; font-size:120%'),
                     actionButton("Fishing above quota","Fishing above quota", icon = icon("weight-scale"), style='padding:50px; font-size:120%'),
                     actionButton("Fishing in a prohibited zone", "Fishing in a prohibited zone", icon = icon("ban"), style='padding:50px; font-size:120%'),
                     actionButton("Fishing out of season", "Fishing out of season", icon = icon("earth-americas"), style='padding:50px; font-size:120%'),
                     actionButton("Fishing without license", "Fishing without license", icon = icon("id-card"), style='padding:50px; font-size:120%'),
                     actionButton("Gear-related offense", "Gear-related offense", icon = icon("gear"), style='padding:50px; font-size:120%'),
                     actionButton("Transhipments", "Transhipments", icon = icon("ship"), style='padding:50px; font-size:120%'),
                     actionButton("Underreporting of fishing catch", "Underreporting of fishing catch", icon = icon("fish"), style='padding:50px; font-size:120%'),
                     actionButton("Underreporting of fishing effort", "Underreporting of fishing effort", icon = icon("dumbbell"), style='padding:50px; font-size:120%'),
                     actionButton("Vessel with false flag", 'Vessel with false flag', icon = icon("flag"), style='padding:50px; font-size:120%')
                     # Add more buttons as needed
                     
              )
            ),
            
            fluidRow(
              column(12, 
                     uiOutput("iuu_text")) # Placeholder for displaying text based on the selected IUU type
            ) # END IUU type text fluidRows
            
            
          
            
            
            ) # end IUU Types tab item


  ) #END tabItems

)



#..................combine all in dashboardPage..................
dashboardPage(header, sidebar, body)