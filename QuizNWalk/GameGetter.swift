//
//  gameGetter.swift
//  QuizNWalk
//
//  Created by Mr X on 2017-03-13.
//  Copyright © 2017 Fredrik Börjesson. All rights reserved.
//

import Foundation

// This function should get a JSON-object with all games. Will be created if I have the time.
// For now only one exists.

func getGames() -> [Game]{
    
    let demoGame = Game(quizName: "Fredrik's Cool Quiz", id: 1)
    demoGame.questions.append(Question("Hur många kromosom par har vi i våra celler?", "23", "64", "42", "15", (51.509979999999999, -0.13370000000000001)))
    demoGame.questions.append(Question("Namnet Ran förekommer i nordisk mytologi. Vad var Ran för något?", "En gudinna", "Ett troll", "En människa", "En gud", (-26.204102800000001 ,28.047305099999999)))
    demoGame.questions.append(Question("Vilket träslag är glasspinnen gjord av?", "Bok", "Alm", "Björk", "Al", (55.755786000000001, 37.617632999999998)))
    demoGame.questions.append(Question("Viket år anföll Japan Pearl Harbour?", "1941", "1945", "1942", "1943", (19.017614699999999, 72.856164399999997)))
    demoGame.questions.append(Question("Vad betyder order demokrati?", "Folkstyre", "Rättvisa", "Folkbildning", "Orättvisa", (35.702069100000003, 139.77532690000001)))
    demoGame.questions.append(Question("Vad heter Nordkoreas nuvarande ledare?", "Kim Jong-un", "Tim Long Li", "Kim Peng", "Slim Shady", (-33.863399999999999, 151.21100000000001)))
    demoGame.questions.append(Question("Vem var formgivaren bakom den klassiska fåtöljen Ägget?", "Arne Jacobsen", "Marcello Siard", "Lena Larsson", "Carl Malmsten", (22.284680999999999, 114.15817699999999)))
    demoGame.questions.append(Question("Hur långt var fartyget Titanic?", "269m", "294m", "189m", "235m", (21.282777800000002, -157.8294444)))
    demoGame.questions.append(Question("Vilken släkt kom Gustav Vasas mamma ifrån?", "Eka", "Sture", "Gren", "Sparre", (37.787358900000001, -122.408227)))
    demoGame.questions.append(Question("Vilket år tillträde John F Kennedy som USAs president?", "1961", "1964", "1960", "1949", (19.435477800000001, -99.1364789)))
    let gameArray = [demoGame]
    return gameArray
}

// London: latitude: 51.509979999999999, longitude: -0.13370000000000001
// Johannesburg: latitude: -26.204102800000001, longitude: 28.047305099999999
// Moska: latitude: 55.755786000000001, longitude: 37.617632999999998
// Mumbai: latitude: 19.017614699999999, longitude: 72.856164399999997
// Tokyo: latitude: 35.702069100000003, longitude: 139.77532690000001
// Sydney: latitude: -33.863399999999999, longitude: 151.21100000000001
// Hong kong: latitude: 22.284680999999999, longitude: 114.15817699999999
// Honolulu: latitude: 21.282777800000002, longitude: -157.8294444
// San Fransisco: latitude: 37.787358900000001, longitude: -122.408227
// Mexico City: latitude: 19.435477800000001, longitude: -99.1364789
// New york: latitude: 40.759211000000001, longitude: -73.984638000000004
