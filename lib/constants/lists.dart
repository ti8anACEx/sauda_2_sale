import 'package:flutter/material.dart';

List devTeam = [
  {
    'CEO': 'Kunal',
  },
  {
    'COO': 'Subhajit',
  },
  {
    'CTO': 'Jit',
  },
  {
    'CFO': 'Saurajit',
  },
];

List<String> sampleHomeScreenImages = [
  "https://plus.unsplash.com/premium_photo-1663931932484-8ed597c6d426?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTN8fG5mdHxlbnwwfHwwfHx8MA%3D%3D&auto=format&fit=crop&w=500&q=60",
  "https://images.unsplash.com/photo-1560419015-7c427e8ae5ba?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTB8fGdhbWluZ3xlbnwwfHwwfHx8MA%3D%3D&auto=format&fit=crop&w=500&q=60",
  "https://plus.unsplash.com/premium_photo-1663931932637-e30332303b71?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8bmZ0fGVufDB8fDB8fHww&auto=format&fit=crop&w=500&q=60",
  "https://images.unsplash.com/photo-1645731504303-860e0da74fee?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTZ8fG5mdHxlbnwwfHwwfHx8MA%3D%3D&auto=format&fit=crop&w=500&q=60",
  "https://plus.unsplash.com/premium_photo-1663931932646-15ceb9c0033f?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8N3x8bmZ0fGVufDB8fDB8fHww&auto=format&fit=crop&w=500&q=60",
  "https://images.unsplash.com/photo-1560421683-6856ea585c78?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NXx8Y3JlYXRpdmV8ZW58MHx8MHx8fDA%3D&auto=format&fit=crop&w=500&q=60",
  "https://images.unsplash.com/photo-1550745165-9bc0b252726f?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTJ8fGdhbWluZ3xlbnwwfHwwfHx8MA%3D%3D&auto=format&fit=crop&w=500&q=60",
  "https://plus.unsplash.com/premium_photo-1663931932484-8ed597c6d426?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTN8fG5mdHxlbnwwfHwwfHx8MA%3D%3D&auto=format&fit=crop&w=500&q=60",
  "https://images.unsplash.com/photo-1560419015-7c427e8ae5ba?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTB8fGdhbWluZ3xlbnwwfHwwfHx8MA%3D%3D&auto=format&fit=crop&w=500&q=60",
  "https://plus.unsplash.com/premium_photo-1663931932637-e30332303b71?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8bmZ0fGVufDB8fDB8fHww&auto=format&fit=crop&w=500&q=60",
];

List<String> describesYouCategoryList = [
  "Artist",
  "Musician/Brand",
  "UI/UX Designer",
  "Entrepreneur",
  "Cloth Design",
  "Other",
];

List homeScreenCarouselList = [
  // path may be the image path
  {"id ": 0, "path": "", "url": ""},
  {"id ": 1, "path": "", "url": ""},
  {"id ": 2, "path": "", "url": ""},
  {"id ": 3, "path": "", "url": ""},
  {"id ": 4, "path": "", "url": ""},
];

List suggestedArtistsForHomeScreen = [
  {
    'id': 0,
    'uid': 'fbaseuid',
    'profile_img': 'link',
    'username': 'halo_infinite',
  },
  {
    'id': 0,
    'uid': 'fbaseuid',
    'profile_img': 'link',
    'username': 'halo_infinite',
  },
  {
    'id': 0,
    'uid': 'fbaseuid',
    'profile_img': 'link',
    'username': 'halo_infinite',
  },
  {
    'id': 0,
    'uid': 'fbaseuid',
    'profile_img': 'link',
    'username': 'halo_infinite',
  },
  {
    'id': 0,
    'uid': 'fbaseuid',
    'profile_img': 'link',
    'username': 'halo_infinite',
  },
];

List suggestedUpdatesForHomeScreen = [
  {
    'id': 0,
    'uid': 'fbaseuid',
    'thumb_img': 'link',
  },
  {
    'id': 0,
    'uid': 'fbaseuid',
    'thumb_img': 'link',
  },
  {
    'id': 0,
    'uid': 'fbaseuid',
    'thumb_img': 'link',
  },
  {
    'id': 0,
    'uid': 'fbaseuid',
    'thumb_img': 'link',
  },
  {
    'id': 0,
    'uid': 'fbaseuid',
    'thumb_img': 'link',
  },
];
List<String> interestTags = [
  "Vintage Art",
  "Motion Graphics",
  "Graphic Design",
  "Animation",
  "VFX",
  "UI/UX",
  "Lofi",
  "Programming",
  "Politics",
  "Data Science",
  "Economy",
];

List customTags = [
  {
    'title': 'Date',
    'color': const Color.fromRGBO(255, 100, 66, 0.71),
    'textColor': Colors.white,
  },
  {
    'title': 'Price',
    'color': const Color.fromRGBO(194, 238, 243, 1),
    'textColor': const Color.fromRGBO(40, 40, 40, 1),
  },
  {
    'title': 'Rate',
    'color': const Color.fromRGBO(212, 253, 219, 1),
    'textColor': Colors.black,
  },
  {
    'title': 'Type',
    'color': const Color.fromRGBO(51, 155, 208, 0.65),
    'textColor': Colors.white,
  },
  {
    'title': 'Pushed',
    'color': const Color.fromRGBO(255, 100, 66, 0.71),
    'textColor': Colors.white,
  },
  {
    'title': 'Not Pushed',
    'color': const Color.fromRGBO(255, 100, 66, 0.71),
    'textColor': Colors.white,
  },
];

List trendingArtistsList = [
  {
    'name': 'kunal_deb',
    'emoji': 'fire',
  },
  {
    'name': 'kunal_deb',
    'emoji': 'happy',
  },
  {
    'name': 'kunal_deb',
    'emoji': 'laugh',
  },
  {
    'name': 'kunal_deb',
    'emoji': '',
  },
  {
    'name': 'kunal_deb',
    'emoji': '',
  },
  {
    'name': 'kunal_deb',
    'emoji': '',
  },
];

List generalNotificationsList = [
  {
    'type': 'follow',
    'profile_img': '',
    'days_passed': 1,
    'username': 'fkin_follower',
    'date': 'July 1, 2069',
    'uid': '',
  },
  {
    'type': 'comment',
    'profile_img': '',
    'days_passed': 1,
    'text':
        'Lorem ipsum dolor sit amet, consectetur, sed do eiusmod tempor incididunt ut labore et',
    'username': 'fkin_follower',
    'date': 'July 1, 2069',
    'url': '',
    'uid': '',
  },
  {
    'type': 'follow',
    'profile_img': '',
    'days_passed': 1,
    'username': 'hero_alom',
    'date': 'July 1, 2069',
    'uid': '',
  },
  {
    'type': 'comment',
    'profile_img': '',
    'days_passed': 1,
    'text': 'Lorem ipsum dolor sit amet, consectetur',
    'username': 'fkin_follower',
    'date': 'July 1, 2069',
    'url': '',
    'uid': '',
  },
  {
    'type': 'comment',
    'profile_img': '',
    'days_passed': 1,
    'text': 'Lorem ipsum dolor sit amet, consectetur',
    'username': 'fkin_follower',
    'date': 'July 1, 2069',
    'url': '',
    'uid': '',
  },
  {
    'type': 'follow',
    'profile_img': '',
    'days_passed': 2,
    'username': 'rmd_sir',
    'date': 'July 1, 2069',
    'uid': '',
  },
  {
    'type': 'follow',
    'profile_img': '',
    'days_passed': 2,
    'username': 'ajey_nagar',
    'date': 'July 1, 2069',
    'uid': '',
  },
  {
    'type': 'comment',
    'profile_img': '',
    'days_passed': 2,
    'text': 'Lorem ipsum dolor sit amet, consectetur',
    'username': 'fkin_follower',
    'date': 'July 1, 2069',
    'url': '',
    'uid': '',
  },
  {
    'type': 'follow',
    'profile_img': '',
    'days_passed': 1,
    'username': 'oh_nly_fans',
    'date': 'July 1, 2069',
    'uid': '',
  },
];

List fairUseList = [
  {
    'type': 'fair_use',
    'profile_img': '',
    'days_passed': 1,
    'price': 6969,
    'username': 'oh_nly_fans',
    'date': 'July 1, 2069',
    'uid': '',
  },
  {
    'type': 'fair_use',
    'profile_img': '',
    'days_passed': 1,
    'price': 6969,
    'username': 'oh_nly_fans',
    'date': 'July 1, 2069',
    'uid': '',
  },
  {
    'type': 'purchase_interest',
    'profile_img': '',
    'days_passed': 1,
    'price': 6969,
    'username': 'oh_nly_fans',
    'date': 'July 1, 2069',
    'uid': '',
  },
  {
    'type': 'fair_use',
    'profile_img': '',
    'days_passed': 1,
    'price': 6969,
    'username': 'oh_nly_fans',
    'date': 'July 1, 2069',
    'uid': '',
  },
  {
    'type': 'purchase_interest',
    'profile_img': '',
    'days_passed': 1,
    'price': 6969,
    'username': 'oh_nly_fans',
    'date': 'July 1, 2069',
    'uid': '',
  },
  {
    'type': 'fair_use',
    'profile_img': '',
    'days_passed': 1,
    'price': 6969,
    'username': 'oh_nly_fans',
    'date': 'July 1, 2069',
    'uid': '',
  },
];
