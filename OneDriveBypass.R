## PURPOSE:   OneDrive sync workaround demo ##
## VERSION:		v0.1 (Dec 2023)               ##
## CREATOR:		Chi Hin Leung                 ##


# 0.Setup ----
# Use pacman to install/load packages required

if (!require(pacman)) install.packages("pacman") 
pacman::p_load(tidyverse,lubridate,dplyr,Microsoft365R,ggplot2,plotly,crosstalk,flexdashboard,markdown,htmltools)


## 0.1 Create the example data frames/objects for this demo ----

# load iris data set

data("iris")


# render markdown file for the demo dashboard

rmarkdown::render("demoDashboard.Rmd", output_file = "temp.html")



# 1.0 Define your SharePoint site ----
# Please replace "Your url" with the url of your SharePoint site.

SP_site <- get_sharepoint_site(site_url = "Your URL")


## 1.1 Set your "SharePoint drive" (Document Library) ----
# A full list of "drives" available on the SharePoint site defined above could now be viewed using the following command:
# SP_site$list_drives()

DocLib <- SP_site$get_drive("Your drive")


## 1.2 Specify your new file path ----
new_filePath <- ''


# 2.0 Upload html file to SharePoint ----
# Conversely we could use Microsoft365R to download files (including .Rdata and .rds ) bypassing OneDrive entirely
DocLib$upload_file(
  "temp.html",
  new_filePath
)


# 3.0 Bonus tricks ----

## 3.1 automating the .aspx "SharePoint Site" workaround ----

# render markdown file for the demo dashboard

rmarkdown::render("demoDashboard.Rmd", output_file = "temp.html")



#### set up OneDrive connection
odb <- get_business_onedrive()


### upload the rendered HTML output file generated above as .aspx.

odb$upload_file(src = "temp.html", dest = "./upload/temp.aspx")


### Define output SharePoint location
### Replace/Add the empty strings and/or $get_item("") according to your SharePoint directory of choice in order to retrieve the directory id of your folder:
#SPfolder <- DocLib$get_item("")$get_item("")$get_item("")$get_item("")


### Replace the empty string below with the itemid of your folder
SPfolder <- DocLib$get_item("")$get_item("")$get_item("")$get_item("")


### Move the .aspx file created to the SharePoint location
(odb$get_item("./upload/temp.aspx"))$copy(dest = "temp.aspx", dest_folder_item = SPfolder)

### Delete the temp file created
odb$get_item("./upload/temp.aspx")$delete()


## 3.2 Teams integration ----

#list chats (private channels) on Teams
#list_chats()
#It would be easier to find it on Teams online (https://teams.microsoft.com/v2/). It is in the url once you've selected the chat that you'd like to send the message to.


# Define Coffee and Code chat ID
cncChat <- get_chat("Chat ID")

# Send message
cncChat$send_message("Hi everyone. This is a live demo.")

# Attachment could also be sent along with the message 
cncChat$send_message("Some useless stuff attached: ", attachments=c("./upload/temp.aspx"))

