# Set up a collection to contain player information. On the server,
# it is backed by a MongoDB collection named "players."



@Players = new Meteor.Collection("players")      # 定义一个mongodb的表


if Meteor.isClient
    Template.leaderboard.players = ->
        return Players.find({}, {sort: {score: -1, name: 1}})

    Template.leaderboard.selected_name = ->
        player = Players.findOne(Session.get('selected_player'))
        return player && player.name

    Template.player.selected = ->
        return if Session.equals('selected_player', this._id) then 'selected' else ''

    Template.leaderboard.events
        'click input.inc': ->
            Players.update(Session.get('selected_player'), {$inc: {score: 5}})

    Template.player.events
        'click': ->
            Session.set("selected_player", this._id)


if Meteor.isServer
    Meteor.startup(->
        if Players.find().count() == 0
            names = [
                'Ada Lovelace'
                'Grace Hopper'
                'Marie Curie'
                'Carl Frindrich Gauss'
                'Nikola Tesla'
                'Claude Shannon'
            ]
            Players.insert({name: i, score: Math.floor(Random.fraction()*10)*5}) for i in names
        )
