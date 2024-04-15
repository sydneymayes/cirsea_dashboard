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
    menuItem(text = "Monitoring Strategies", tabName = "monitoring_strategies", icon = icon("magnifying-glass")),
    menuItem(text = "Additional Resources", tabName = "resources", icon = icon("book")),
    menuItem(text = "Methodology", tabName = "methodology", icon = icon("asterisk"))
    
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
                                       strong("About The Project")),
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
                                         strong("Instructions")),
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
                                     selected = NULL),
                  
                  
                  # div for satellite widgets
                  div(
                    h5("Satellite Specifications:", style = "margin-top: 20px; font-weight: bold;"),
                    
                    # Free or not
                    materialSwitch(
                      inputId = "sat_cost_input",
                      label = "Free Data", 
                      value = FALSE,
                      status = "primary"
                    ),
                    
                    materialSwitch(
                      inputId = "sat_delivery_input",
                      label = "Near Real-time Delivery", 
                      value = FALSE,
                      status = "success"
                    )
                  )
                  
                  
                  

              ), #end first input box
              
              # output box for temporary MS -- remove later
                     
              box(width = 8,

                  title = strong("Recommended Monitoring Strategies"),

                  # data table output ---
                  dataTableOutput(outputId = "iuu_table_output") %>%
                    withSpinner(color = "skyblue", type = 1),
                  
                  # div for satellites
                  div(
                    
                  h4("Satellite Data Table", style = "margin-top: 30px; font-weight: bold;"),
                  # data table output for satellites ---
                  dataTableOutput(outputId = "sat_table_output") %>%
                    withSpinner(color = "skyblue", type = 1),
                  # if there is no sat data
                  textOutput("no_data_message")
                  ) # end div


                     ), # END output
              
              # descriptions box
              box(width = 8,
                  title = strong("Possible Monitoring Strategies"),
                 
                  div(
                    h4("Sensor and Platform Pairings:", style = "margin-top: 10px; margin-bottom: 20px; font-weight: bold;"),
                    uiOutput(outputId = "sensor_platform_output")
                  ),
                   
                  
                  # div for satellite widgets
                  div(
                    h4("Satellite Options:", style = "margin-top: 30px; margin-bottom:20px; font-weight: bold;"),
                    uiOutput(outputId = "satellite_output")
                  )
                  
              ), # end descriptions box
              
              
              
              ), # End fluidRow
              
             
            # # fluidRow 2 ---
            # fluidRow(
            #   
            #  
            #   ), # END second fluid row
            

    ), # END tool tabItem
    
    
    # IUU Types tab item
    tabItem(tabName = "iuu_types",
            
            # how to use
            fluidRow(
              column(width = 12,
              div("Click on an IUU Type to learn more.", style = "margin-bottom: 20px; padding:50x")
            )),
    
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
                     actionButton("Dark Vessels (not broadcasting location via VMS/AIS)", 
                                  HTML(paste(icon("moon"),
                                             "<br>Dark Vessels")), 
                                  style='width:200px; height:150px; font-size:120%; white-space:normal;'),
                     actionButton("Fishing above quota",
                                  HTML(paste(icon("weight-scale"), 
                                             "<br>Fishing above quota")), 
                                  style='width:200px; height:150px; font-size:120%; white-space:normal;'),
                     actionButton("Fishing in a prohibited zone", 
                                  HTML(paste(icon("ban"), 
                                             "<br>Fishing in a prohibited zone")), 
                                 style='width:200px; height:150px; font-size:120%; white-space:normal;'),
                     actionButton("Fishing out of season", 
                                  HTML(paste(icon("earth-americas"), 
                                             "<br>Fishing out of season")), 
                                 style='width:200px; height:150px; font-size:120%; white-space:normal;'),
                     actionButton("Fishing without license", 
                                  HTML(paste(icon("id-card"), 
                                             "<br>Fishing without license")), 
                                 style='width:200px; height:150px; font-size:120%; white-space:normal;'),
                     actionButton("Gear-related offense", 
                                  HTML(paste(icon("gear"), 
                                             "<br>Gear-related offense")), 
                                 style='width:200px; height:150px; font-size:120%; white-space:normal;'),
                     actionButton("Transhipments", 
                                  HTML(paste(icon("ship"),
                                             "<br>Illegal Transhipments")), 
                                 style='width:200px; height:150px; font-size:120%; white-space:normal;'),
                     actionButton("Underreporting of fishing catch", 
                                  HTML(paste(icon("fish"),
                                             "<br>Underreporting of fishing catch")), 
                                  style='width:200px; height:150px; font-size:120%; white-space:normal;'),
                     actionButton("Underreporting of fishing effort", 
                                  HTML(paste(icon("dumbbell"),
                                             "<br>Underreporting of fishing effort")), 
                                  style='width:200px; height:150px; font-size:120%; white-space:normal;'),
                     actionButton("Vessel with false flag", 
                                  HTML(paste(icon("flag"),
                                             '<br>Vessel with false flag')), 
                                 style='width:200px; height:150px; font-size:120%; white-space:normal;'),
                     actionButton("Prohibited Species", 
                                  HTML(paste(icon("fish-fins"),
                                             '<br>Fishing for prohibited species')), 
                                  style='width:200px; height:150px; font-size:120%; white-space:normal;'),
                     actionButton("Bycatch", 
                                  HTML(paste(icon("shrimp"),
                                             '<br>Illegal bycatch and discard')), 
                                  style='width:200px; height:150px; font-size:120%; white-space:normal;'),
                     actionButton("Reporting", 
                                  HTML(paste(icon("book"),
                                             '<br>Noncompliance with reporting requirements')), 
                                  style='width:200px; height:150px; font-size:120%; white-space:normal;')
                     # Add more buttons as needed
                     
              )
            ),
            
            fluidRow(
              column(12, 
                     uiOutput("iuu_text")) # Placeholder for displaying text based on the selected IUU type
            ), # END IUU type text fluidRows
            
            
            
            ###### Might need to do something like this to render images for buttons
            
            # fluidRow(
            #   column(12, 
            #          imageOutput("iuu_image")) # Placeholder for displaying text based on the selected IUU type
            # ), # END IUU type image fluidrow
            # 
            # 
            
            
            ), # end IUU Types tab item
    
    
    # Monitoring Strategies tab item
    tabItem(tabName = "monitoring_strategies",
            # Sensors and how to use
            fluidRow(
              column(width = 12,
              div("Click on a Monitoring Strategy to learn more.", style = "margin-bottom: 20px;"),
              div("Sensors", style = "margin-bottom: 20px; font-weight: bold;", style = "margin-bottom: 20px;")
              
            )),
            
            
            # Sensors fluidRow ----
            fluidRow(
              
              column(12,
                     # Define buttons for sensors
                     actionButton("hydroacoustics", 
                                  HTML(paste(icon("ear-listen"),
                                             "<br>Hydroacoustics")), 
                                  style = 'width:200px; height:150px; font-size:120%; white-space:normal;'),
                     actionButton("long_range_camera", 
                                  HTML(paste(icon("camera"),
                                             "<br>Cameras")), 
                                  style = 'width:200px; height:150px; font-size:120%; white-space:normal;'),
                     actionButton("onboard_observer", 
                                  HTML(paste(icon("glasses"),
                                             "<br>Onboard Observers")), 
                                  style = 'width:200px; height:150px; font-size:120%; white-space:normal;'),
                     actionButton("radar",
                                  HTML(paste(icon("satellite-dish"),
                                             "<br>Radar")), 
                                  style = 'width:200px; height:150px; font-size:120%; white-space:normal;'),
                     actionButton("radio_frequency", 
                                  HTML(paste(icon("radio"),
                                             "<br>Radio Frequency")),
                                  style = 'width:200px; height:150px; font-size:120%; white-space:normal;'),
                     actionButton("AIS/VMS", 
                                  HTML(paste(icon("radio"),
                                             "<br>AIS and VMS")),
                                  style = 'width:200px; height:150px; font-size:120%; white-space:normal;'),
                     actionButton("Electronic Monitoring Systems", 
                                  HTML(paste(icon("radio"),
                                             "<br>Electronic Monitoring Systems")),
                                  style = 'width:200px; height:150px; font-size:120%; white-space:normal;'),
                     actionButton("Satellites", 
                                  HTML(paste(icon("radio"),
                                             "<br>Satellites")),
                                  style = 'width:200px; height:150px; font-size:120%; white-space:normal;'),
                     # Add more buttons as needed
              )
            ),
            
            fluidRow(
              column(12,
                     uiOutput("sensor_text")) # Placeholder for displaying text based on the selected IUU type
            ), # END Sensors  fluidRows
            
            
            # Platforms and how to use
            fluidRow(
              column(width = 12,
              div("Platforms", style = "margin-bottom: 20px; margin-top: 20px; font-weight: bold;", style = "margin-bottom: 20px;")
              
            )),
          
            
            # Platforms fluidRow ----
            fluidRow(
              
              column(12,
                     # Define buttons for platforms
                     actionButton("aerial_drone", 
                                  HTML(paste(icon("helicopter"),
                                             "<br>Aerial Drone<br>")), 
                                  style = 'width:200px; height:150px; font-size:120%; white-space: normal;'),
                     actionButton("manned_aircraft", 
                                  HTML(paste(icon("plane"), 
                                             "<br>Manned Aircraft")), 
                                  style = 'width:200px; height:150px; font-size:120%'),
                     actionButton("manned_vessel", 
                                  HTML(paste(icon("ship"),
                                             "<br>Manned Vessel")), 
                                  style = 'width:200px; height:150px; font-size:120%'),
                     actionButton("on_shore_command_center", 
                                  HTML(paste(icon("computer"),
                                             "<br>Onshore Command Center")), 
                                  style = 'width:200px; height:150px; font-size:120%; white-space: normal;'),
                     actionButton("smart_buoy", 
                                  HTML(paste(icon("code-commit"),
                                             "<br>Smart Buoy")), 
                                  style = 'width:200px; height:150px; font-size:120%'),
                     actionButton("usv",
                                  HTML(paste(icon("water"),
                                             "<br>USV")), 
                                  style = 'width:200px; height:150px; font-size:120%'),
                     # Add more buttons as needed
              )
            ),
            
            fluidRow(
              column(12, 
                     uiOutput("platform_text")) # Placeholder for displaying text based on the selected IUU type
            ) # END Platforms fluidRows
            
            
            
    ),# End Monitoring Strategies tab item
    
    
    
    # Additional Resources tab item
    tabItem(tabName = "resources",
            
    ), # END RESOURCES TAB ITEM
    
    
    # Methodology tab item
    tabItem(tabName = "methodology",
            
    ) # END METHODOLOGY TAB ITEM


  ) #END tabItems

)



#..................combine all in dashboardPage..................
dashboardPage(header, sidebar, body)