/*
    This work, "Customizable (Multi-) Day Pillbox" (https://www.printables.com/model/12345-customizable-multi-day-pillbox),
    is adapted from "Customizable Pill Dosette Box" (https://www.printables.com/model/70577-customizable-pill-dosette-box)
    by @einarjh (https://www.printables.com/@einarjh_110431),
    used under CC-BY-SA 4.0 (https://creativecommons.org/licenses/by-sa/4.0/).
    
    "Customizable (Multi-) Day Pillbox" (https://www.printables.com/model/12345-customizable-multi-day-pillbox)
    is licensed under CC-BY-SA 4.0 (https://creativecommons.org/licenses/by-sa/4.0/)
    by Niels Ganser (https://www.printables.com/@niels_1017960).
*/

/*
    Modify the below parameters to align with those in you pillbox definition
*/

// How many chambers (per day) does your box have?
chambers = 4;

// The (inner) dimensions of each individual chamber of your pillbox.
chamberWidth = 21;
chamberLength = 30;

// The thickness of the walls separating the daily chambers from one another.
thinWall = 1.5;

// If you find that your lid doesn't fit into the channels of the pillbox, you can try lowering
// the following variable ever so slightly.
lidChannel = 1;

// The list of icons to embed above each of the chambers. The paths must be in the same
// directory as this file.
//
// If your pillbox has more than 4 chambers, you must add more icons to the below.abs
//
// If your pillbox has less than 4 chambers, modify the below list to ensure that the correct
// icons are picked. For example, if your pillbox has 2 chambers, one for the morning, and
// one for the evening, remove the third and foruth entries.
icons = [
    "icons/weather-sunset-up.svg",
    "icons/weather-sunny.svg",
    "icons/weather-sunset-down.svg",
    "icons/weather-night.svg"
];

/*
    This concludes the safe-ish to edit portion of the file. Proceed with caution.
*/

// Calculate the lid dimensions. The width and height are reduced to ensure that the lid
// fits into the channels. The width is reduced by 50% of the channel, the height is 
// reduces by 25%.
lidLength = (chamberLength + thinWall) * chambers;
lidWidth = (chamberWidth + (lidChannel * 2)) - (lidChannel / 2);
lidHeight = lidChannel * 0.75;

difference() {    
    lidBase();
    chambersIcons();
}

module chamberIcon(chamberIdx) {
    translate([
        ((chamberLength + thinWall) * chamberIdx) + (chamberLength / 2),
        chamberWidth / 2,
        lidHeight / 2
    ])
    rotate([0,0,90])
    linear_extrude(1) import(icons[chamberIdx], center=true, dpi=33);
}

module chambersIcons() {
    for(chamberIdx = [0:chambers]) {
        chamberIcon(chamberIdx);
    }
}

module lidBase() {
    union(){
        cube([lidLength, lidWidth, lidHeight]);
        translate([lidLength -6 , lidWidth * 0.1 , lidHeight]) cube([3, lidWidth * 0.8, 1]);
    }
}