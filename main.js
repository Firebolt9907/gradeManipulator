// Programmers: Rishu, Nick, Caden
// Increment this counter if you don't understand the code: 71
// MUTE THE TAB DURING DEVELOPMENT FOR THE SAKE OF UR EARS banger music though

// Nick can u figure out y the characters are being randomized every round

var SIZE_MULTIPLIER = 0.75;
var X_CANVAS = 1920*SIZE_MULTIPLIER;
var Y_CANVAS = 1080*SIZE_MULTIPLIER;
var ROUND = 1; // yk that all caps symbolizes a constant variable right?

var people = ["Samanyu","Thomas","Sam","Akilan","Jack","Carmine","Ken","Tharun","Filmon","Caden","Rishu","Nick","Aden","Luis","Landon","Kaden","Ryan","Daniel","Jordan","Ella","Juan","Caelan","Aashish","Adam","Marvin","Grant","Jonahs","Amelia","Mr. Palmer","Mr. Bird","Mr. Ross","John Xena"];
var chars = [];
var rounds = [[],[],[],[],[]];

// BREAKING: EACH ROUND WILL HAVE THE CHARACTER INDEX OF BOTH PLAYERS AND WINNING PLAYER AT THE END OF THE FORMAT

// format: [[name1, name2, nameOfWinner, indexOfWinner], [name3, name4, nameOfWinner, indexOfWinner], ...
// ex: [["Samanyu", "Thomas", "Thomas", 1], ["Sam", "Akilan", "Sam", 0], ... 
// nameOfWinner defaults to "", indexOfWinner defaults to -1, becomes 
var textForRound = [[],[],[],[],[]];

var backgroundMusic = new Audio("https://codehs.com/uploads/6914b07e81daaa60884a64833402cc71");
var winningMusic = new Audio("https://codehs.com/uploads/0391592f15c47be5ba9d92e9145e9e14");
var winningWords = new Audio("https://codehs.com/uploads/bc7e6948da551f3a63ce3674a3ff2e78");

// start function
function start() {
    setSize(X_CANVAS,Y_CANVAS);
    let bracket = new WebImage("https://codehs.com/uploads/4feadb0fc3efad1434e06b7240e3fe09");
    bracket.setPosition(0,0);
    bracket.setSize(getWidth(),getHeight());
    add(bracket);
    setOrder(ROUND);
    setText(ROUND);
    setChars(ROUND);
    // test(2);
    
    // setAnimation(1);
    backgroundMusic.play();
    backgroundMusic.loop = true;
    mouseClickMethod(mouseClickText);
}

function test(roundWanted) {
    if(roundWanted < 5){
        for(var i = 1; i < roundWanted; i++){
            for(var j = 0; j < 32/(2**i); j++) {
                makeWinner(people[j],i,j, chars[j]);
            }
            setOrder(i+1);
            setText(i+1);
            setChars(i+1);
            ROUND++;
        }
    } else {
        for(var i = 1; i < 4; i++){
            for(var j = 0; j < 32/(2**i); j++) {
                makeWinner(people[j],i,j, chars[j]);
            }
            setOrder(i+1);
            setText(i+1);
            ROUND++;
        }
        makeWinner(people[0],4,0, chars[0]);
        makeWinner(people[1],4,1, chars[0]);
        setOrder(5);
        vsScreen();
        // setTimeout(finalFight,5000);
        ROUND++;
    }
    
}

// fetches location of left clicks
function mouseClickText(e) {
    let elem = getElementAt(e.getX(), e.getY());
    let failCount = 0
    for(var i = 4; i >= 0; i--){
        if (textForRound[i].includes(elem)) {
            changePlayerStatus(i,elem);
        } else {
            failCount++;
        }
    }
    if(failCount == 5){
        console.log("No player found at click location");
    }
    // print(people.length);
    if(people.length <= 32 * 2 ** (-1*ROUND) && ROUND < 4){
        setOrder(ROUND + 1);
        println(rounds[ROUND])
        setText(ROUND + 1);
        setChars(ROUND + 1);
        ROUND++;
    }
    // if(people.length <= 8 && ROUND == 2){
    //     setOrder(3);
    //     println(rounds[ROUND])
    //     setText(3);
    //     ROUND++;
    // }
    // if(people.length <= 4 && ROUND == 3){
    //     setOrder(4);
    //     println(rounds[ROUND]);
    //     setText(4);
    //     ROUND++;
    // }
    if(people.length <= 2 && ROUND == 4){
        setOrder(5);
        println(rounds[ROUND]);
        vsScreen();
        // setTimeout(finalFight,5000);
        ROUND++;
    }
    
}

function changePlayerStatus(roundMinusOne,elem) {
    console.log("Round " + (roundMinusOne+1) +  " player found: " + elem.getText());
    let index = 0;
    for (let i = rounds[roundMinusOne].length; i >0; i--) {
        let nameOne = rounds[roundMinusOne][i-1][0];
        let nameTwo = rounds[roundMinusOne][i-1][1];
        if (nameOne === elem.getText() || nameTwo === elem.getText()) {
            index = i-1;
            break;
        }
    }
    // Rudimentary undo !!(COULD LATER CAUSE ISSUES)!!
    if(elem.getColor() == Color.green){
        elem.setColor(Color.black); // dependent on line 84
        rounds[roundMinusOne][index][2] = "";
        rounds[roundMinusOne][index][3] = -1;
        // people.push(elem.getText()); // looked at the array and this line is causing redundancy
    } else if(rounds[roundMinusOne][index][3] != -1) {
        // Checks if other person is already checked
    } else {
        elem.setColor(Color.green); // dependent on line 77
        // println(index)
        makeWinner(elem.getText(), roundMinusOne+1, index); 
    }
}

// overlays text on top of bracket 
function setText(roundNumber) {
    // Left-side names
    for(var i = 0; i < rounds[roundNumber-1].length/2; i++){
        // Text for each person & vs
        var firstNameText = new Text(rounds[roundNumber-1][i][0],(18*SIZE_MULTIPLIER).toString() + "pt Arial");
        var vs = new Text(" vs ",(18*SIZE_MULTIPLIER).toString() + "pt Arial");
        var secondNameText = new Text(rounds[roundNumber-1][i][1], (18*SIZE_MULTIPLIER).toString() + "pt Arial");
        // Y-COORD
        var topPadding = 40*2**(roundNumber-1)+134*i*2**(roundNumber-1);
        if (i > rounds[roundNumber-1].length/4 - 1) {
            topPadding -= 22;
            if (roundNumber == 2 && i == 2) {
                topPadding -= 10;
            }
            if (roundNumber == 3 && i == 1) {
                topPadding -= 14;
            }
        }
        if (i > rounds[roundNumber-1].length/4) {
            topPadding -= 18;
        }
        // First Name Stuff
        firstNameText.setPosition(24+200*(roundNumber-1)*SIZE_MULTIPLIER-.05*(3.4**roundNumber)*SIZE_MULTIPLIER,topPadding*SIZE_MULTIPLIER);
        firstNameText.setColor(Color.black);
        textForRound[roundNumber-1].push(firstNameText);
        add(firstNameText);
        // Vs
        var xVs = firstNameText.getX() + firstNameText.getWidth();
        vs.setPosition(xVs,topPadding*SIZE_MULTIPLIER);
        vs.setColor(Color.black);
        add(vs);
        // Second Name Stuff
        var xSecondNameText = vs.getX() + vs.getWidth();
        secondNameText.setPosition(xSecondNameText,topPadding*SIZE_MULTIPLIER);
        secondNameText.setColor(Color.black);
        textForRound[roundNumber-1].push(secondNameText);
        add(secondNameText);
    }
    
    // Right-side names
    for(var i = rounds[roundNumber-1].length/2; i < rounds[roundNumber-1].length; i++){
       // Text for each person & vs
        var firstNameText = new Text(rounds[roundNumber-1][i][0],(18*SIZE_MULTIPLIER).toString() + "pt Arial");
        var vs = new Text(" vs ",(18*SIZE_MULTIPLIER).toString() + "pt Arial");
        var secondNameText = new Text(rounds[roundNumber-1][i][1], (18*SIZE_MULTIPLIER).toString() + "pt Arial");
        // Changes anchor to top-right corner of text
        firstNameText.setAnchor({vertical: 1, horizontal: 1});
        vs.setAnchor({vertical: 1, horizontal: 1});
        secondNameText.setAnchor({vertical: 1, horizontal: 1});
        // Y-coord
        var topPaddingRightSide = 40*2**(roundNumber-1)+134*(i-rounds[roundNumber-1].length/2)*2**(roundNumber-1);
        if ((i-rounds[roundNumber-1].length/2) > rounds[roundNumber-1].length/4 - 1) {
            topPaddingRightSide -= 22;
            if (roundNumber == 2 && (i-rounds[roundNumber-1].length/2) == 2) {
                topPaddingRightSide -= 10;
            }
            if (roundNumber == 3 && (i-rounds[roundNumber-1].length/2) == 1) {
                topPaddingRightSide -= 14;
            }
        }
        if ((i-rounds[roundNumber-1].length/2) > rounds[roundNumber-1].length/4) {
            topPaddingRightSide -= 18;
        }
        // Second Name Stuff
        secondNameText.setPosition(X_CANVAS-(40+200*(roundNumber-1))*SIZE_MULTIPLIER-3+.1*(3.4**roundNumber)*SIZE_MULTIPLIER,topPaddingRightSide*SIZE_MULTIPLIER);
        secondNameText.setColor(Color.black);
        textForRound[roundNumber-1].push(secondNameText);
        add(secondNameText);
        // Vs
        var xVs = secondNameText.getX() - secondNameText.getWidth();
        vs.setPosition(xVs,topPaddingRightSide*SIZE_MULTIPLIER);
        vs.setColor(Color.black);
        add(vs);
        // First Name Stuff
        var xFirstNameText = vs.getX() - vs.getWidth();
        firstNameText.setPosition(xFirstNameText,topPaddingRightSide*SIZE_MULTIPLIER);
        firstNameText.setColor(Color.black);
        textForRound[roundNumber-1].push(firstNameText);
        add(firstNameText);
    }
    
    // sound on prompt on bottom
    var soundOn = new Text("Turn the sound on!", "16pt Arial");
    soundOn.setPosition((getWidth()-soundOn.getWidth())/2, getHeight() - 10);
    soundOn.setColor(Color.black);
    add(soundOn);
}

// overlays characters on top of bracket 
function setChars(roundNumber) {
    // Left-side characters
    for(var i = 0; i < rounds[roundNumber-1].length/2; i++){
        // Text for each person & vs
        println(people);
        println(chars);
        var firstNameText = new WebImage(characters[rounds[roundNumber-1][i][4]]);
        // var vs = new Text(" vs ","9pt Arial")
        var secondNameText = new WebImage(characters[rounds[roundNumber-1][i][5]]);
        // Y-COORD
        var topPadding = 30+40*2**(roundNumber-1)+134*i*2**(roundNumber-1);
        if (i > rounds[roundNumber-1].length/4 - 1) {
            topPadding -= 34;
            
            if (roundNumber == 2 && i == 2) {
                topPadding -= 8;
            }
            if (roundNumber == 3 && i == 1) {
                topPadding -= 6;
            }
        }
        if (i > rounds[roundNumber-1].length/4) {
            topPadding -= 10;
        }
        if (roundNumber == 2) {
            topPadding += 50;
        }
        // First Name Stuff
        firstNameText.setPosition(25+200*(roundNumber-1)*SIZE_MULTIPLIER-.1*(3.4**roundNumber)*SIZE_MULTIPLIER,topPadding*SIZE_MULTIPLIER);
		firstNameText.setSize(60*SIZE_MULTIPLIER,60*SIZE_MULTIPLIER);
        firstNameText.setColor(Color.black);
        add(firstNameText);
        // Vs
        // var xVs = firstNameText.getX() + firstNameText.getWidth();
        // vs.setPosition(xVs,topPadding);
        // vs.setColor(Color.black);
        // add(vs);
        // Second Name Stuff
        secondNameText.setPosition(135*SIZE_MULTIPLIER+200*(roundNumber-1)*SIZE_MULTIPLIER-.1*(3.4**roundNumber)*SIZE_MULTIPLIER,topPadding*SIZE_MULTIPLIER);
		secondNameText.setSize(60*SIZE_MULTIPLIER,60*SIZE_MULTIPLIER);
        secondNameText.setColor(Color.black);
        add(secondNameText);
    }
    
    // Right-side characters
    // for(var i = rounds[roundNumber-1].length/2; i < rounds[roundNumber-1].length; i++){
    //   // Text for each person & vs
    //     var firstNameText = new Text(rounds[roundNumber-1][i][0], "9pt Arial");
    //     var vs = new Text(" vs ","9pt Arial")
    //     var secondNameText = new Text(rounds[roundNumber-1][i][1], "9pt Arial")
    //     // Changes anchor to top-right corner of text
    //     firstNameText.setAnchor({vertical: 1, horizontal: 1});
    //     vs.setAnchor({vertical: 1, horizontal: 1});
    //     secondNameText.setAnchor({vertical: 1, horizontal: 1});
    //     // Y-coord
    //     var topPaddingRightSide = 20*2**(roundNumber-1)+67*(i-rounds[roundNumber-1].length/2)*2**(roundNumber-1);
    //     if ((i-rounds[roundNumber-1].length/2) > rounds[roundNumber-1].length/4 - 1) {
    //         topPaddingRightSide -= 11;
    //         if (roundNumber == 2 && (i-rounds[roundNumber-1].length/2) == 2) {
    //             topPaddingRightSide -= 5;
    //         }
    //         if (roundNumber == 3 && (i-rounds[roundNumber-1].length/2) == 1) {
    //             topPaddingRightSide -= 7;
    //         }
    //     }
    //     if ((i-rounds[roundNumber-1].length/2) > rounds[roundNumber-1].length/4) {
    //         topPaddingRightSide -= 9;
    //     }
    //     // Second Name Stuff
    //     secondNameText.setPosition(X_CANVAS-(15+100*(roundNumber-1))-3+.05*(3.4**roundNumber),topPaddingRightSide);
    //     secondNameText.setColor(Color.black);
    //     textForRound[roundNumber-1].push(secondNameText);
    //     add(secondNameText);
    //     // Vs
    //     var xVs = secondNameText.getX() - secondNameText.getWidth();
    //     vs.setPosition(xVs,topPaddingRightSide);
    //     vs.setColor(Color.black);
    //     add(vs);
    //     // First Name Stuff
    //     var xFirstNameText = vs.getX() - vs.getWidth();
    //     firstNameText.setPosition(xFirstNameText,topPaddingRightSide);
    //     firstNameText.setColor(Color.black);
    //     textForRound[roundNumber-1].push(firstNameText);
    //     add(firstNameText);
    // }
}

// // TODO: add street fighter animations into each branch of bracket
// // edit: gifs do not animate in js graphics
// function setAnimation(roundNumber) {
//     for(var i = 0; i < rounds[roundNumber-1].length/2; i++){
//         var topPadding = 20+10*2**(roundNumber-1)+67*i;
//         if (i > 3) {
//             topPadding -= 15;
//         }
//         if (i > 4) {
//             topPadding -= 5;
//         }
//         let bracket = new WebImage("https://codehs.com/uploads/784c3b33ea3a35daaed24f3a8ddcff41");
//         bracket.setPosition(15+50*(roundNumber-1),topPadding);
//         bracket.setSize(50,35);
//         add(bracket);
//     }
//     for(var i = rounds[roundNumber-1].length/2; i < rounds[roundNumber-1].length; i++){
//         // var nameText = new Text((rounds[roundNumber-1][i][0] + " vs " + rounds[roundNumber-1][i][1]), "9pt Arial");
//         // nameText.setAnchor({vertical: 0, horizontal: 1});
//         // var topPadding = 10*2**(roundNumber-1)+67*(i-rounds[roundNumber-1].length/2);
//         // if (i > 3+ rounds[roundNumber-1].length/2) {
//         //     topPadding -= 15;
//         // }
//         // if (i > 4 + rounds[roundNumber-1].length/2) {
//         //     topPadding -= 5;
//         // }
//         // nameText.setPosition(1920*0.5-(10+100*(roundNumber-1)),topPadding);
//         // nameText.setColor(Color.black);
//         // textForRound[roundNumber-1].push(nameText);
//         // add(nameText);
//         var topPadding = 20+10*2**(roundNumber-1)+67*(i-rounds[roundNumber-1].length/2);
//         if (i > 3 + rounds[roundNumber-1].length/2) {
//             topPadding -= 15;
//         }
//         if (i > 4 + rounds[roundNumber-1].length/2) {
//             topPadding -= 5;
//         }
//         let bracket = new WebImage("https://codehs.com/uploads/784c3b33ea3a35daaed24f3a8ddcff41");
//         bracket.setAnchor({vertical: 0, horizontal: 1});
//         bracket.setPosition(getWidth()-(20+50*(roundNumber-1)),topPadding);
//         bracket.setSize(50,35);
//         add(bracket);
//     }
// }

// randomizes order and organizes data
function setOrder(roundNumber) {
    if (roundNumber == 1) {
        for (var e = 0; e < people.length; e++) {
            chars.push(Randomizer.nextInt(0, characters.length-1));
        }
        var shuffled = shuffleArray(people, chars);
        for (var i = 0; i < shuffled[0].length; i += 2) {
            rounds[roundNumber-1].push([shuffled[0][i], shuffled[0][i+1], "", -1, shuffled[1][i], shuffled[1][i+1], -1]);
        }  
    } else {
        for(var i = 0; i<people.length; i+= 2) {
            rounds[roundNumber-1].push([people[i], people[i+1], "", -1, chars[people.indexOf(people[i])], chars[people.indexOf(people[i+1])], -1]);
        }
    }
    console.log(rounds);
}


// modifies data when player wins (fixed) (not sound though that's broken)
function makeWinner(name, round, index, character) {
    if (round == 5) {
        backgroundMusic.pause();
        winningWords.play();
        setTimeout(function(){winningMusic.play();}, 2000);
    }
    var loser = rounds[round-1][index][1-rounds[round-1][index].indexOf(name)];
    rounds[round-1][index][2] = name;
    rounds[round-1][index][3] = rounds[round-1][index].indexOf(name);
    rounds[round-1][index][6] = rounds[round-1][index][rounds[round-1][index][3]+4];
    println("removing: " + people.indexOf(loser) + people[people.indexOf(loser)] + chars[people.indexOf(loser)]);
    people.remove(people.indexOf(loser));
	chars.remove("", people.indexOf(loser));
}

// array randomizing function using Fisher-Yates shuffle algorithm
function shuffleArray(array1, array2) {
  for (let i = array1.length - 1; i > 0; i--) {
    const j = Math.floor(Math.random() * (i + 1));
    [array1[i], array1[j]] = [array1[j], array1[i]];
    [array2[i], array2[j]] = [array2[j], array2[i]];
  }
  return [array1, array2];
}

function vsScreen(){
    removeAll();
    fightScreen.setPosition(0,0);
    fightScreen.setSize(X_CANVAS,Y_CANVAS);
    add(fightScreen);
    var char1 = new WebImage("https://codehs.com/uploads/a970dd53d040b9be4c2c4ebdecea0f15");
    char1.setPosition(-20*SIZE_MULTIPLIER,140*SIZE_MULTIPLIER);
    char1.setSize(1000*SIZE_MULTIPLIER,1000*SIZE_MULTIPLIER);
    add(char1);
    var vsText = new Text("Vs.",(120*SIZE_MULTIPLIER).round().toString() + "pt Impact");
    vsText.setColor(Color.white);
    vsText.setAnchor({vertical: 0.5,horizontal: 0.5});
    vsText.setPosition(getWidth()/2,getHeight()/2);
    add(vsText);
    var nameOne = rounds[ROUND][0][0].toUpperCase();
    var nameTwo = rounds[ROUND][0][1].toUpperCase();
    var nameOneText = new Text(nameOne,(60*SIZE_MULTIPLIER).round().toString() + "pt Impact");
    var nameTwoText = new Text(nameTwo,(60*SIZE_MULTIPLIER).round().toString() + "pt Impact");
    nameOneText.rotate(-1.5);
    nameTwoText.rotate(-1.5);
    nameOneText.setColor(Color.white);
    nameTwoText.setColor(Color.white);
    nameOneText.setPosition(110*SIZE_MULTIPLIER,132*SIZE_MULTIPLIER);
    nameTwoText.setPosition(535*2*SIZE_MULTIPLIER,132*SIZE_MULTIPLIER);
    add(nameOneText);
    add(nameTwoText);
}

function finalFight(){
    removeAll();
    battlefield.setPosition(0,0);
    battlefield.setSize(X_CANVAS*(2)**.5,540*(2)**.5);
    add(battlefield);
}

var fightScreen = new WebImage("https://codehs.com/uploads/054e4ef9efdf0568cef8fd755d9c2e5b");
var battlefield = new WebImage("https://codehs.com/uploads/46b9360c9e9064ea87245ff1ae97c2d4");
var ken = new WebImage("https://codehs.com/uploads/15decb301708b3f9d0439790c1de5069");
var ryu = new WebImage("https://codehs.com/uploads/66e7a7a918a049c0c289bea598d13cd6");


var characters = [
    "https://codehs.com/uploads/ef7e4d283b50d69e24ba77ac4f272c22", 
    "https://codehs.com/uploads/9433948cd0879126afaa0c4a9d055b62", 
    "https://codehs.com/uploads/b67728acd9e0336e7689e3235cf6bdea",
    "https://codehs.com/uploads/7cf10716a99e833f568a8b9a8cde2998",
    "https://codehs.com/uploads/3c5f463e198d7a38f2d3a48ab04812e6",
    "https://codehs.com/uploads/4b4c2e834fecb3a57fdee7606640a6fb", 
    "https://codehs.com/uploads/803b87e3f1217ec83246614688b6e557", 
    "https://codehs.com/uploads/d277076a6565f61446fca40da6545dc1", 
    "https://codehs.com/uploads/041ffce081046d6a3a5df5d62e16a921",
    "https://codehs.com/uploads/54edc07e59d6ca42f1ea4f156c144dd5", 
    "https://codehs.com/uploads/14232fd4f72116e5f547b0292150c994",
    "https://codehs.com/uploads/e329461ff950b1d4c1238cf464403010", 
    "https://codehs.com/uploads/ad3fee1535d47d9605ae38c8c14f295e",
    "https://codehs.com/uploads/d61d471a270123ab66baa727f3c257e9", 
    "https://codehs.com/uploads/34527a74b8e25d198fdf9fb312a238e6", 
    "https://codehs.com/uploads/bd606323b2afa75bc23cf24a5a44ff1c", 
    "https://codehs.com/uploads/5a85b5c5b805b835686e5f16e9623580",
    "https://codehs.com/uploads/43e0697e4a29a1e34e03d4a8d903910a",
    "https://codehs.com/uploads/d566f6b8491a1a827efc4e3e285aa176",
    "https://codehs.com/uploads/5314e28f47c0e3ea752d4bd5bdd74bda",
    "https://codehs.com/uploads/bdec463d45754064bad22fe7c7888fc1",
    "https://codehs.com/uploads/bc965b8b36f15e6462ca4bd486993a5a",
    "https://codehs.com/uploads/a4494ca8092e5ca274ab50c8cd64f7a0",
    "https://codehs.com/uploads/dc7f11615e4bbd2a096ab5dc4b22b859",
    "https://codehs.com/uploads/78a09d1030a76ffbdd0b7c94a9cd658d",
    "https://codehs.com/uploads/029802d3b2ac35864fb0c29ba476cd18",
    "https://codehs.com/uploads/ece99ab612e6475ac2a7ca23507bbe74",
    "https://codehs.com/uploads/ea8baa01cb20475356faf3aea874b733",
    "https://codehs.com/uploads/c76e8bbe1afc32767ebe75b17a861652",
    "https://codehs.com/uploads/adc4e588c0f985849c55bfd82db0f509",
    "https://codehs.com/uploads/bd19937cb0440e22f1144fb587ede4f2",
    "https://codehs.com/uploads/9c0e7ec79b14abe1ddd34fcf9daf67cb",
    "https://codehs.com/uploads/6211fb0bfb007e3a7fcc194b5ee9a1ac",
    "https://codehs.com/uploads/2c114d3afd92041fc349e55952f1c829",
    "https://codehs.com/uploads/dd6358e893c8fb37c58681eac8a82078",
    "https://codehs.com/uploads/0432679f0b2d6545829eeefeb492c11e",
    "https://codehs.com/uploads/8c1c15e5dcf56c7c503ae34a5debec1c",
    "https://codehs.com/uploads/c169f03f2621a1be7aa3c8e6739d16cb",
    "https://codehs.com/uploads/28fcf8f45e55608215bdbfc2378825ff",
    "https://codehs.com/uploads/9ebc41c9786cac570f6cdf07e229de77",
    "https://codehs.com/uploads/27984b6bb8f673fbeb11cbf70ecceb4d",
    "https://codehs.com/uploads/41c2f568ee704790f181056e88e9a1d9",
    "https://codehs.com/uploads/fa45dd97596d4eb0c56bf0ed8186e479",
    "https://codehs.com/uploads/b11fc27f1b13b865cc827f56725f7a57",
    "https://codehs.com/uploads/9389afccb5a35575ba53cb1f94ad1d28",
    "https://codehs.com/uploads/d684bd2243fc3759f02bb51b3d5b0911",
    "https://codehs.com/uploads/e5bd1450c46ceb59332c2252058edffa",
    "https://codehs.com/uploads/2766f935f98ff93f6a953dad8eaee411",
    "https://codehs.com/uploads/b455909430c6454315c78a11747a1b61",
    "https://codehs.com/uploads/9d5ffd643b7bbda6b40af5f24e2472a2",
    "https://codehs.com/uploads/af72e5876c11fae3428df0d301704e1f",
    "https://codehs.com/uploads/7cd4d22f11ce11c9fd675ca417a1f31c",
    "https://codehs.com/uploads/485725e86d833bd0955a05a4082d2586",
    "https://codehs.com/uploads/e7c2fc9bd5db24ce237c20c61a62f6b0",
];

var left = -1;
var right = -1;