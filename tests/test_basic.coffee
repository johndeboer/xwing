common = require './common'

common.setup()


casper.test.begin "Page comes up", (test) ->
    casper.start "app/index.html", ->
        @waitUntilVisible '.tab-content'

    .then ->
        nav_sel = 'ul.nav.nav-pills'
        test.assertVisible nav_sel
        for tab_text in [ "Card Browser", "About" ]
            test.assertSelectorHasText nav_sel, tab_text

        test.assertSelectorHasText '.squad-name-container .squad-name', 'Unnamed Squadron'
        test.assertSelectorHasText common.selectorForShipDropdown, 'Select a ship'

    .run ->
        test.done()

casper.test.begin "Basic functionality", (test) ->
    common.waitForStartup('#rebel-builder')

    common.addShip('#rebel-builder', 'X-Wing', 'Blue Squadron Escort')
    common.assertShipHasPoints(test, '#rebel-builder', 1, 41)
    common.assertTotalPoints(test, '#rebel-builder', 41)
    .then ->
        test.assertSelectorHasText "#rebel-builder #{common.selectorForUpgradeIndex 1, 1} .select2-choice", 'No Torpedo Upgrade'
        test.assertSelectorHasText "#rebel-builder #{common.selectorForUpgradeIndex 1, 2} .select2-choice", 'No Astromech Upgrade'
        test.assertSelectorHasText "#rebel-builder #{common.selectorForUpgradeIndex 1, 3} .select2-choice", 'No Modification Upgrade'
        test.assertSelectorHasText "#rebel-builder #{common.selectorForUpgradeIndex 1, 4} .select2-choice", 'No Configuration Upgrade'
        test.assertDoesntExist "#rebel-builder #{common.selectorForUpgradeIndex 1, 5}"

    .run ->
        test.done()

casper.test.begin "Basic empire functionality", (test) ->
    common.waitForStartup('#rebel-builder')
    common.openEmpireBuilder()

    common.addShip('#empire-builder', 'TIE Fighter', 'Academy Pilot')
    common.assertShipHasPoints(test, '#empire-builder', 1, 23)
    common.assertTotalPoints(test, '#empire-builder', 23)
    .then ->
        test.assertSelectorHasText "#empire-builder #{common.selectorForUpgradeIndex 1, 1} .select2-choice", 'No Modification'
        test.assertDoesntExist "#empire-builder #{common.selectorForUpgradeIndex 1, 2}"

    .run ->
        test.done()

casper.test.begin "Add/remove torpedo upgrade", (test) ->
    common.waitForStartup('#rebel-builder')

    common.addShip('#rebel-builder', 'X-Wing', 'Blue Squadron Escort')
    common.addUpgrade('#rebel-builder', 1, 1, 'Proton Torpedoes')
    common.assertShipHasPoints(test, '#rebel-builder', 1, 50)
    common.assertTotalPoints(test, '#rebel-builder', 50)

    common.removeUpgrade('#rebel-builder', 1, 1)
    common.assertShipHasPoints(test, '#rebel-builder', 1, 41)
    common.assertTotalPoints(test, '#rebel-builder', 41)
    .then ->
        test.assertSelectorHasText "#rebel-builder #{common.selectorForUpgradeIndex 1, 1} .select2-choice", 'No Torpedo Upgrade'

    .run ->
        test.done()

casper.test.begin "Add/remove astromech upgrade", (test) ->
    common.waitForStartup('#rebel-builder')

    common.addShip('#rebel-builder', 'X-Wing', 'Blue Squadron Escort')
    common.addUpgrade('#rebel-builder', 1, 2, 'R5-D8')
    common.assertShipHasPoints(test, '#rebel-builder', 1, 48)
    common.assertTotalPoints(test, '#rebel-builder', 48)

    common.removeUpgrade('#rebel-builder', 1, 2)
    common.assertShipHasPoints(test, '#rebel-builder', 1, 41)
    common.assertTotalPoints(test, '#rebel-builder', 41)
    .then ->
        test.assertSelectorHasText "#rebel-builder #{common.selectorForUpgradeIndex 1, 2} .select2-choice", 'No Astromech Upgrade'

    .run ->
        test.done()

casper.test.begin "Add/remove modification", (test) ->
    common.waitForStartup('#rebel-builder')

    common.addShip('#rebel-builder', 'X-Wing', 'Blue Squadron Escort')
    common.addUpgrade('#rebel-builder', 1, 3, 'Afterburners')
    common.assertShipHasPoints(test, '#rebel-builder', 1, 49)
    common.assertTotalPoints(test, '#rebel-builder', 49)

    common.removeUpgrade('#rebel-builder', 1, 3)
    common.assertShipHasPoints(test, '#rebel-builder', 1, 41)
    common.assertTotalPoints(test, '#rebel-builder', 41)
    .then ->
        test.assertSelectorHasText "#rebel-builder #{common.selectorForUpgradeIndex 1, 3} .select2-choice", 'No Modification Upgrade'

    .run ->
        test.done()

casper.test.begin "Multiple upgrades", (test) ->
    common.waitForStartup('#rebel-builder')

    common.addShip('#rebel-builder', 'X-Wing', 'Blue Squadron Escort')
    common.addUpgrade('#rebel-builder', 1, 1, 'Proton Torpedoes')
    common.addUpgrade('#rebel-builder', 1, 2, 'R5-D8')
    common.addUpgrade('#rebel-builder', 1, 3, 'Afterburners')
    common.assertShipHasPoints(test, '#rebel-builder', 1, 65)
    common.assertTotalPoints(test, '#rebel-builder', 65)

    .run ->
        test.done()

casper.test.begin "Add/remove ships", (test) ->
    common.waitForStartup('#rebel-builder')

    common.addShip('#rebel-builder', 'X-Wing', 'Blue Squadron Escort')
    common.addShip('#rebel-builder', 'Y-Wing', 'Gray Squadron Bomber')
    common.addShip('#rebel-builder', 'B-Wing', 'Blue Squadron Pilot')

    common.assertTotalPoints(test, '#rebel-builder', 115)

    common.removeShip('#rebel-builder', 2)
    common.assertTotalPoints(test, '#rebel-builder', 83)

    common.removeShip('#rebel-builder', 2)
    common.assertTotalPoints(test, '#rebel-builder', 41)

    common.removeShip('#rebel-builder', 1)
    common.assertTotalPoints(test, '#rebel-builder', 0)

    common.addShip('#rebel-builder', 'X-Wing', 'Blue Squadron Escort')
    common.assertTotalPoints(test, '#rebel-builder', 41)

    .run ->
        test.done()
