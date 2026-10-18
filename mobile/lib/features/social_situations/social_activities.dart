import 'package:flutter/material.dart';

import 'models/social_activity.dart';
import 'social_situations_texts.dart';

// Temporary Material icons until the final illustrations are ready.
const List<SocialActivity> socialActivities = [
  SocialActivity(
    title: SocialSituationsTexts.playWithFriend,
    icon: Icons.sports_soccer,
  ),
  SocialActivity(
    title: SocialSituationsTexts.creativeTurns,
    icon: Icons.palette,
  ),
  SocialActivity(
    title: SocialSituationsTexts.share,
    icon: Icons.volunteer_activism,
  ),
  SocialActivity(
    title: SocialSituationsTexts.understandFeelings,
    icon: Icons.favorite,
  ),
];
