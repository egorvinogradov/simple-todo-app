Tasks = new Meteor.Collection "tasks"

`_tasks = Tasks`

class Todo

    constructor: (@collection) ->

    initialize: ->

        Template.tasks.events

            "keyup .form__textarea": (e) =>
                if e.which is 13
                    form = $(".form__textarea")
                    text = form.val().trim()
                    if text
                        parentTaskId = @getParentTaskIdByEvent e
                        if parentTaskId
                            @add text, parentTaskId
                        else
                            @add text
                        form.val("").focus()

            "click .form__add": (e) =>
                form = $(".form__textarea")
                text = form.val().trim()
                if text
                    parentTaskId = @getParentTaskIdByEvent e
                    if parentTaskId
                        @add text, parentTaskId
                    else
                        @add text
                    form.val ""

            "click .tasks__status-remove": (e) =>
                id = $(e.currentTarget)
                    .parents(".tasks__item")
                    .data("id")
                @remove id

            "click .tasks__status-add": (e) =>
                id = @getParentTaskIdByEvent e
                _.each @collection.find(form: true).fetch(), (task) =>
                    selector = _id: task._id
                    @collection.update selector, $set:
                        form: false
                @update id, form: true

            "click .tasks__status-item": (e) =>
                status = $(e.currentTarget).data("value")
                id = @getParentTaskIdByEvent e
                @update id, status: status

        Template.tasks.tasks = => @getTemplateTasks()

    getParentTaskIdByEvent: (e) ->
        $(e.currentTarget)
            .parents(".tasks__item")
            .data("id")

    getTemplateTasks: ->

        appendChildTasks = (parent) =>
            parent.children = @collection.find(parent: parent._id).fetch() or null
            if parent.children?.length
                parent.children.map appendChildTasks
            parent

        tasks = @collection.find(parent: null).fetch()
        if tasks?.length
            tasks.map appendChildTasks

    add: (text, parentTaskId) ->
        text
            .split(/\n/)
            .forEach (row) =>
                rowText = row.trim()
                if rowText
                    @collection.insert
                        date: Date.today().toString "yyyy-mm-dd"
                        text: rowText
                        status: "opened"
                        parent: parentTaskId or null

    remove: (id) ->
        console.log('remove', id)
        @collection.remove _id: id

    update: (id, data) ->
        selector = _id: id
        @collection.update selector, $set: data



if Meteor.isClient
    app = new Todo Tasks
    app.initialize()

    `_app = app`
