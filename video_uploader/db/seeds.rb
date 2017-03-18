# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Admin.create!(email: 'upload@engineers.sg', password: 'password1234', password_confirmation: 'password1234')

# Engineers.SG
Playlist.create(title: 'Meetup Videos', playlist_uid: 'PLECEw2eFfW7hYMucZmsrryV_9nIc485P1', playlist_source: 'youtube')

# FOSSASIA 2017
# Playlist.create(title: 'FOSSASIA 2017', playlist_uid: 'PLzZVLecTsGpLhEwJlgVLP-36T7b8AjRG1', playlist_source: 'youtube')

# Michael Cheng
# Playlist.create(title: 'Test Playlist', playlist_uid: 'PLyyvDe8MX3xlcdaNAhoMgc2hAl5HAntTi', playlist_source: 'youtube')
