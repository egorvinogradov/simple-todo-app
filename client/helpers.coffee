Handlebars.registerHelper "console", (items, options) ->
    unless window.__condoleCounter
        window.__condoleCounter = 1;
    console.log(window.__condoleCounter, '> Template console', items);
    window.__condoleCounter++;
    ""
