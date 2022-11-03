
# COMPLAINT for QB-core

Step 1
Set coords in cl_complaint.lua # Currently set to normal PD station
Step 2
Set the webhook in sv-complaint.lua
Step 3
Add the items from below
Step 4
Into [inventoryname]/html/js/app.js around row 400 you will see statements that look like:

        } else if (itemData.name == "driver_license") {
            $(".item-info-title").html("<p>" + itemData.label + "</p>");
            $(".item-info-description").html(
                "<p><strong>First Name: </strong><span>" +
                itemData.info.firstname +
                "</span></p><p><strong>Last Name: </strong><span>" +
                itemData.info.lastname +
                "</span></p><p><strong>Birth Date: </strong><span>" +
                itemData.info.birthdate +
                "</span></p><p><strong>Licenses: </strong><span>" +
                itemData.info.type +
                "</span></p>"
            );
# Below that, add this:

        } else if (itemData.name == "complaint") {
            $(".item-info-title").html("<p>" + itemData.label + "</p>");
            $(".item-info-description").html(
                "<p><strong>Name: </strong><span>" +
                itemData.info.name +
                "</span></p><p><strong>Phone Number: </strong><span>" +
                itemData.info.number +
                "</span></p><p><strong>Date: </strong><span>" +
                itemData.info.date +
                "</span></p><p><strong>Type of Complaint: </strong><span>" +
                itemData.info.typer +
                "</span></p><p><strong>Information: </strong><span>" +
                itemData.info.infor +
                "</span></p>"
            );


# Item too add. Using pictures from mk-items myself, so you can use that if you want # Drop items in [inventoryname]/html/images
['complaint'] 						 = {['name'] = 'complaint', 			 	  	  	['label'] = 'Police Complaint', 	['weight'] = 200, 		['type'] = 'item', 		['image'] = 'complaint.png', 				['unique'] = true, 	['useable'] = false, 	['shouldClose'] = false,   ['combinable'] = nil,   ['description'] = ''},

From Sunwing
