///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import
// dart format off

part of 'strings.g.dart';

// Path: <root>
typedef TranslationsEn = Translations; // ignore: unused_element
class Translations with BaseTranslations<AppLocale, Translations> {
	/// Returns the current translations of the given [context].
	///
	/// Usage:
	/// final t = Translations.of(context);
	static Translations of(BuildContext context) => InheritedLocaleData.of<AppLocale, Translations>(context).translations;

	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	Translations({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.en,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <en>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	dynamic operator[](String key) => $meta.getTranslation(key);

	late final Translations _root = this; // ignore: unused_field

	Translations $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => Translations(meta: meta ?? this.$meta);

	// Translations

	/// en: 'App Documentation'
	String get app_doc => 'App Documentation';

	/// en: 'Contact Developers'
	String get contact_dev => 'Contact Developers';

	/// en: 'Language'
	String get language => 'Language';

	/// en: 'Report a Bug'
	String get report_bug => 'Report a Bug';

	/// en: 'Exit Session'
	String get exit => 'Exit Session';

	/// en: 'Amomimus Center'
	String get center => 'Amomimus Center';

	/// en: 'For Help and Support Queries'
	String get support_queries => 'For Help and Support Queries';

	/// en: 'HELP & SUPPORT'
	String get help_support => 'HELP & SUPPORT';

	/// en: 'Public Name'
	String get public_name => 'Public Name';

	/// en: 'Privacy & Settings'
	String get privacy_settings => 'Privacy & Settings';

	/// en: 'Danger Zone'
	String get danger_zone => 'Danger Zone';

	/// en: 'Deleting your account will permanently wipe all local session data, resonation histories, and saved settings. This action cannot be undone.'
	String get delete_account_warning => 'Deleting your account will permanently wipe all local session data, resonation histories, and saved settings. This action cannot be undone.';

	/// en: 'Privacy'
	String get privacy => 'Privacy';

	/// en: 'About'
	String get about => 'About';

	/// en: 'Policy'
	String get policy => 'Policy';

	/// en: 'Options'
	String get options => 'Options';

	/// en: 'How Amomimus Works'
	String get how_it_works => 'How Amomimus Works';

	/// en: 'Report a Bug / Glitch'
	String get report_bug_glitch => 'Report a Bug / Glitch';

	/// en: 'Terms of '
	String get terms_of => 'Terms of ';

	/// en: 'Privacy & Rules Agreement'
	String get privacy_rules_agreement => 'Privacy & Rules Agreement';

	/// en: 'Last updated: May 2026 1. Keep It Ghostly You're a ghost here, bud. No real names, no phone numbers, and definitely no leaking your ex's address or social media handles. We want this space to be completely detached from your real-world drama. If you accidentally slip up and reveal your true identity or doxx someone else, don't expect a warning. We will scrub that post faster than you can blink, and your access might vanish along with it. Keep it 100% incognito. 2. Don't Be a Total Jerk Ranting? Cool. Crying? We got you. Venting about how much your job or life sucks is exactly why we built this app, so feel free to let off some steam without holding back. But throwing straight-up hate speech, targeted harassment, or bullying someone who is already down? Nah, that's a fast pass to getting booted. There is a very clear line between venting your pain and just being a miserable troll. 3. Zero Data Retention We don't buy, sell, or even care about your personal data. What happens in Amomimus, stays in Amomimus. Your temporary sessions are encrypted and will be wiped clean periodically from our servers. 4. No Commercial Spamming This platform is made for human emotions, not for selling your crypto coins, promoting your online shop, or spamming affiliate links. Commercial ads without permission will result in an immediate hardware ban. 5. Age Restriction Users must be at least 18 years old to participate in this blind community. The contents shared here can be mature, heavy, and raw. Protect your own mental health before reading others' rants. 6. Content Ownership Disclaimer You own the words you write, but by posting them here, you grant Amomimus a non-exclusive right to display them anonymously within the app interface. We will never claim your stories as our corporate property. 7. Report and Moderation System Even ghosts have boundaries. If you find a post that violates our community safety guidelines, use the report feature immediately. Our automated system and moderators review flags 24/7. 8. Illegal Activities Ban Do not use this app to plan, coordinate, or promote any form of illegal activities, physical violence, or real-world harm. We comply with digital safety regulations and will take strict action against violations. 9. Application Analytics We only collect anonymous technical logs (such as crash reports, device model, and system language) to ensure the app runs smoothly on your phone. None of these logs can be traced back to your real identity. 10. Changes to the Terms Amomimus reserves the right to update these rules anytime to adapt to new laws or features. Continued use of the app after updates means you agree to follow the latest ghostly protocols.'
	String get privacy_rules_text => 'Last updated: May 2026\n\n1. Keep It Ghostly\nYou\'re a ghost here, bud. No real names, no phone numbers, and definitely no leaking your ex\'s address or social media handles. We want this space to be completely detached from your real-world drama.\n\nIf you accidentally slip up and reveal your true identity or doxx someone else, don\'t expect a warning. We will scrub that post faster than you can blink, and your access might vanish along with it. Keep it 100% incognito.\n\n2. Don\'t Be a Total Jerk\nRanting? Cool. Crying? We got you. Venting about how much your job or life sucks is exactly why we built this app, so feel free to let off some steam without holding back.\n\nBut throwing straight-up hate speech, targeted harassment, or bullying someone who is already down? Nah, that\'s a fast pass to getting booted. There is a very clear line between venting your pain and just being a miserable troll.\n\n3. Zero Data Retention\nWe don\'t buy, sell, or even care about your personal data. What happens in Amomimus, stays in Amomimus. Your temporary sessions are encrypted and will be wiped clean periodically from our servers.\n\n4. No Commercial Spamming\nThis platform is made for human emotions, not for selling your crypto coins, promoting your online shop, or spamming affiliate links. Commercial ads without permission will result in an immediate hardware ban.\n\n5. Age Restriction\nUsers must be at least 18 years old to participate in this blind community. The contents shared here can be mature, heavy, and raw. Protect your own mental health before reading others\' rants.\n\n6. Content Ownership Disclaimer\nYou own the words you write, but by posting them here, you grant Amomimus a non-exclusive right to display them anonymously within the app interface. We will never claim your stories as our corporate property.\n\n7. Report and Moderation System\nEven ghosts have boundaries. If you find a post that violates our community safety guidelines, use the report feature immediately. Our automated system and moderators review flags 24/7.\n\n8. Illegal Activities Ban\nDo not use this app to plan, coordinate, or promote any form of illegal activities, physical violence, or real-world harm. We comply with digital safety regulations and will take strict action against violations.\n\n9. Application Analytics\nWe only collect anonymous technical logs (such as crash reports, device model, and system language) to ensure the app runs smoothly on your phone. None of these logs can be traced back to your real identity.\n\n10. Changes to the Terms\nAmomimus reserves the right to update these rules anytime to adapt to new laws or features. Continued use of the app after updates means you agree to follow the latest ghostly protocols.';

	/// en: 'Amomimus System Language:'
	String get system_language => 'Amomimus System Language:';

	/// en: 'Date of Birth:'
	String get dob => 'Date of Birth:';

	/// en: '* Required â€” you must select your date of birth'
	String get dob_required => '* Required â€” you must select your date of birth';

	/// en: 'Agreement verified'
	String get agreement_verified => 'Agreement verified';

	/// en: 'Ready to verified our terms?'
	String get ready_to_verify => 'Ready to verified our terms?';

	/// en: 'You must be at least 18 years old to use Amomimus.'
	String get age_warning => 'You must be at least 18 years old to use Amomimus.';

	/// en: 'Accept & Continue'
	String get accept_continue => 'Accept & Continue';

	/// en: 'Select your birthday first'
	String get select_birthday_first => 'Select your birthday first';

	/// en: 'Accept the terms first'
	String get accept_terms_first => 'Accept the terms first';

	/// en: 'Amomimus Mobile App'
	String get mobile_app => 'Amomimus Mobile App';

	/// en: 'A secure and a room of anonymous venting platform designed for digital catharsis.'
	String get app_desc => 'A secure and a room of anonymous venting platform designed for digital catharsis.';

	/// en: 'Create Your '
	String get create_your => 'Create Your ';

	/// en: 'ANONYMOUS USERNAME'
	String get anonymous_username_label => 'ANONYMOUS USERNAME';

	/// en: 'Leave blank for a random name'
	String get leave_blank_random => 'Leave blank for a random name';

	/// en: 'Enter your username'
	String get enter_username_hint => 'Enter your username';

	/// en: 'AMOMIMUS ID GENERATOR'
	String get id_generator_title => 'AMOMIMUS ID GENERATOR';

	/// en: 'Random Generate ID:'
	String get random_generate_id => 'Random Generate ID:';

	/// en: 'CHOOSE YOUR AMOMUS AVATAR'
	String get choose_avatar_title => 'CHOOSE YOUR AMOMUS AVATAR';

	/// en: 'Incomplete Selection'
	String get incomplete_selection => 'Incomplete Selection';

	/// en: 'Proceed'
	String get proceed => 'Proceed';

	/// en: 'Please choose your Amomus Avatar first!'
	String get choose_avatar_first => 'Please choose your Amomus Avatar first!';

	/// en: 'You haven't '
	String get incomplete_selection_desc_1 => 'You haven\'t ';

	/// en: '. You won't be restricted, but you will not have your custom name displayed to you. The system will auto-generate a random one instead. Do you want to proceed?'
	String get incomplete_selection_desc_2 => '.\n\nYou won\'t be restricted, but you will not have your custom name displayed to you. The system will auto-generate a random one instead. Do you want to proceed?';

	/// en: 'You found the easter egg'
	String get you_found_easter_egg => 'You found the easter egg';

	/// en: 'Developer:'
	String get developer => 'Developer:';

	/// en: 'Skip'
	String get skip => 'Skip';

	/// en: 'Welcome to '
	String get welcome_to => 'Welcome to ';

	/// en: 'A safe space to share your thoughts, ask questions, and connect with others.'
	String get safe_space_desc => 'A safe space to share your thoughts, ask questions, and connect with others.';

	/// en: 'Your real identity is hidden beneath an '
	String get identity_hidden_desc_1 => 'Your real identity is hidden beneath an ';

	/// en: ' name.'
	String get identity_hidden_desc_2 => ' name.';

	/// en: 'We ensure your identity is protected. Chat freely without worrying about who is on the other side.'
	String get identity_protected_desc => 'We ensure your identity is protected.\nChat freely without worrying about who is on the other side.';

	/// en: 'Introducing Amomimus Indicators:'
	String get intro_indicators => 'Introducing Amomimus Indicators:';

	/// en: 'Neutral'
	String get neutral => 'Neutral';

	/// en: ' users who participate normally.'
	String get users_participate_normally => ' users who participate normally.';

	/// en: 'Amoral'
	String get amoral => 'Amoral';

	/// en: ' or nonchalant users to watch out for.'
	String get users_nonchalant => ' or nonchalant users to watch out for.';

	/// en: 'Toxic'
	String get toxic => 'Toxic';

	/// en: ' users flagged by the community.'
	String get users_flagged => ' users flagged by the community.';

	/// en: 'Safe & '
	String get safe_and => 'Safe & ';

	/// en: 'Respectful'
	String get respectful => 'Respectful';

	/// en: 'We value privacy and kindness. Please follow our community rules while you explore.'
	String get value_privacy_desc => 'We value privacy and kindness. Please follow our community rules while you explore.';

	/// en: 'App Version:'
	String get app_version => 'App Version:';

	/// en: 'Share to Chat'
	String get share_to_chat => 'Share to Chat';

	/// en: 'Create a Post'
	String get create_post => 'Create a Post';

	/// en: 'What's on your mind anonymously?'
	String get whats_on_your_mind => 'What\'s on your mind anonymously?';

	/// en: 'Send Post'
	String get send_post => 'Send Post';

	/// en: 'Notifications'
	String get notifications => 'Notifications';

	/// en: 'No notifications yet'
	String get no_notifications => 'No notifications yet';

	/// en: 'No feeds available.'
	String get no_feeds => 'No feeds available.';

	/// en: 'Comments'
	String get comments => 'Comments';

	/// en: 'No comments yet. Be the first to comment!'
	String get no_comments => 'No comments yet. Be the first to comment!';

	/// en: 'Add a comment...'
	String get add_comment => 'Add a comment...';

	/// en: 'Replying to'
	String get replying_to => 'Replying to';

	/// en: 'Chat this Amomim'
	String get chat_this_amomim => 'Chat this Amomim';

	/// en: 'Delete this post'
	String get delete_post => 'Delete this post';

	/// en: 'Hide this feed'
	String get hide_feed => 'Hide this feed';

	/// en: 'Report this Amomim'
	String get report_amomim => 'Report this Amomim';

	/// en: 'Resonated'
	String get resonated => 'Resonated';

	/// en: 'Resonates'
	String get resonates => 'Resonates';

	/// en: 'Chat Request Pending...'
	String get chat_req_pending => 'Chat Request Pending...';

	/// en: 'Your Amomimus Indicator is NOISE. Chat requests are prohibited.'
	String get indicator_noise_limit => 'Your Amomimus Indicator is NOISE. Chat requests are prohibited.';

	/// en: 'GHOST Indicator limit reached: 7 chat requests per day.'
	String get ghost_limit_reached => 'GHOST Indicator limit reached: 7 chat requests per day.';

	/// en: 'Initiate Chat'
	String get initiate_chat => 'Initiate Chat';

	/// en: 'Are you sure you want to chat with the author of this post? They will see you as '
	String get confirm_chat => 'Are you sure you want to chat with the author of this post?\n\nThey will see you as ';

	/// en: 'Cancel'
	String get cancel => 'Cancel';

	/// en: 'Send Request'
	String get send_request => 'Send Request';

	/// en: 'Chat Request Sent!'
	String get chat_req_sent => 'Chat Request Sent!';

	/// en: 'Feed hidden.'
	String get feed_hidden => 'Feed hidden.';

	/// en: 'Bio'
	String get bio => 'Bio';

	/// en: 'No bio yet'
	String get no_bio_yet => 'No bio yet';

	/// en: 'Write your bio...'
	String get write_bio => 'Write your bio...';

	/// en: 'Select Date'
	String get select_date => 'Select Date';

	/// en: 'OK'
	String get ok => 'OK';

	/// en: 'Invalid format'
	String get error_format => 'Invalid format';

	/// en: 'Invalid date'
	String get error_invalid => 'Invalid date';

	/// en: 'resonated with your post'
	String get notif_resonate => 'resonated with your post';

	/// en: 'commented on your post'
	String get notif_comment => 'commented on your post';

	/// en: 'replied to your comment'
	String get notif_reply => 'replied to your comment';

	/// en: 'Just now'
	String get just_now => 'Just now';

	/// en: 'Bio updated!'
	String get bio_updated => 'Bio updated!';

	/// en: 'Coins Redemption'
	String get coins_redemption => 'Coins Redemption';

	/// en: 'Redeemed 100 Coins!'
	String get redeemed_100_coins => 'Redeemed 100 Coins!';

	/// en: 'Vault & Merit'
	String get vault_merit => 'Vault & Merit';

	/// en: 'My Coins'
	String get my_coins => 'My Coins';

	/// en: 'Owned'
	String get owned => 'Owned';

	/// en: 'Sticker Stash'
	String get sticker_stash => 'Sticker Stash';

	/// en: 'Amomimus Indicators:'
	String get amomimus_indicators => 'Amomimus Indicators:';

	/// en: 'Recent Resonates'
	String get recent_resonates => 'Recent Resonates';

	/// en: 'See All'
	String get see_all => 'See All';

	/// en: 'No recent resonates.'
	String get no_recent_resonates => 'No recent resonates.';

	/// en: 'All Resonates'
	String get all_resonates => 'All Resonates';

	/// en: 'No resonates yet'
	String get no_resonates_yet => 'No resonates yet';

	/// en: 'Delete Post'
	String get delete_post_title => 'Delete Post';

	/// en: 'Are you sure you want to delete this post? This will remove it from the feed.'
	String get delete_post_confirm => 'Are you sure you want to delete this post? This will remove it from the feed.';

	/// en: 'Delete Account'
	String get delete_account => 'Delete Account';

	/// en: 'Delete'
	String get delete => 'Delete';

	/// en: 'Profile Locked'
	String get profile_locked => 'Profile Locked';

	/// en: 'You need to establish a chat connection with this user to view their full profile.'
	String get locked_desc => 'You need to establish a chat connection with this user to view their full profile.';

	/// en: 'Profile'
	String get profile => 'Profile';

	/// en: 'No active user.'
	String get no_active_user => 'No active user.';

	/// en: 'Incoming Requests'
	String get incoming_requests => 'Incoming Requests';

	/// en: 'No incoming requests'
	String get no_incoming_requests => 'No incoming requests';

	/// en: 'Chat request accepted!'
	String get chat_req_accepted => 'Chat request accepted!';

	/// en: 'Messages'
	String get messages => 'Messages';

	/// en: 'Amomus List'
	String get amomus_list => 'Amomus List';

	/// en: 'Switch Account'
	String get switch_account => 'Switch Account';

	/// en: 'No accounts registered yet.'
	String get no_accounts_registered => 'No accounts registered yet.';

	/// en: 'Chat Requests'
	String get chat_requests => 'Chat Requests';

	/// en: 'Chat Request'
	String get chat_request_title => 'Chat Request';

	/// en: 'Sending a chat request to this amomimus will reveal your registered username "'
	String get chat_request_desc1 => 'Sending a chat request to this amomimus will reveal your registered username "';

	/// en: '" instead of your feed name "'
	String get chat_request_desc2 => '" instead of your feed name "';

	/// en: '". They will also be able to see your profile if they accept.'
	String get chat_request_desc3 => '".\n\nThey will also be able to see your profile if they accept.';

	/// en: 'Delete Chat'
	String get delete_chat_title => 'Delete Chat';

	/// en: 'Are you sure you want to delete this chat with '
	String get delete_chat_confirm_prefix => 'Are you sure you want to delete this chat with ';

	/// en: '?'
	String get delete_chat_confirm_suffix => '?';

	/// en: 'Chat with '
	String get chat_deleted_prefix => 'Chat with ';

	/// en: ' deleted'
	String get chat_deleted_suffix => ' deleted';

	/// en: 'Memories'
	String get memories => 'Memories';

	/// en: 'No memories pinned yet.'
	String get no_memories_pinned => 'No memories pinned yet.';

	/// en: 'Are you sure you want to delete this chat?'
	String get delete_chat_room_confirm => 'Are you sure you want to delete this chat?';

	/// en: 'You can only pin up to 9 memories. Unpin one first!'
	String get pin_limit_error => 'You can only pin up to 9 memories. Unpin one first!';

	/// en: 'Write message...'
	String get write_message => 'Write message...';

	/// en: 'Reply'
	String get reply => 'Reply';

	/// en: 'App Documentation'
	String get doc_title => 'App Documentation';

	/// en: 'Legal & Privacy Policy'
	String get doc_category_legal => 'Legal & Privacy Policy';

	/// en: '1. Data Collection'
	String get doc_rule_1_title => '1. Data Collection';

	/// en: 'We collect minimal data necessary for core features. Your anonymous identifier is not linked to your personal identity.'
	String get doc_rule_1_desc => 'We collect minimal data necessary for core features. Your anonymous identifier is not linked to your personal identity.';

	/// en: '2. End-to-End Encryption'
	String get doc_rule_2_title => '2. End-to-End Encryption';

	/// en: 'All chat messages are end-to-end encrypted. We cannot read your private messages.'
	String get doc_rule_2_desc => 'All chat messages are end-to-end encrypted. We cannot read your private messages.';

	/// en: '3. Session Data'
	String get doc_rule_3_title => '3. Session Data';

	/// en: 'Local session data is stored securely on your device. Clearing your app data will permanently erase your local history.'
	String get doc_rule_3_desc => 'Local session data is stored securely on your device. Clearing your app data will permanently erase your local history.';

	/// en: '4. Third-Party Services'
	String get doc_rule_4_title => '4. Third-Party Services';

	/// en: 'We do not sell or share your data with third parties. Any external integrations are strictly for operational purposes.'
	String get doc_rule_4_desc => 'We do not sell or share your data with third parties. Any external integrations are strictly for operational purposes.';

	/// en: '5. User Content Liability'
	String get doc_rule_5_title => '5. User Content Liability';

	/// en: 'You are solely responsible for the content you post. Amomimus is not liable for user-generated content.'
	String get doc_rule_5_desc => 'You are solely responsible for the content you post. Amomimus is not liable for user-generated content.';

	/// en: '6. Anonymity Guarantee'
	String get doc_rule_6_title => '6. Anonymity Guarantee';

	/// en: 'Your public interactions remain anonymous unless you explicitly choose to reveal your identity via a chat request.'
	String get doc_rule_6_desc => 'Your public interactions remain anonymous unless you explicitly choose to reveal your identity via a chat request.';

	/// en: '7. Account Deletion'
	String get doc_rule_7_title => '7. Account Deletion';

	/// en: 'You have the right to delete your account at any time. This action is irreversible and wipes all associated records.'
	String get doc_rule_7_desc => 'You have the right to delete your account at any time. This action is irreversible and wipes all associated records.';

	/// en: '8. Harassment & Abuse'
	String get doc_rule_8_title => '8. Harassment & Abuse';

	/// en: 'We maintain a strict zero-tolerance policy against harassment. Violators will be permanently banned.'
	String get doc_rule_8_desc => 'We maintain a strict zero-tolerance policy against harassment. Violators will be permanently banned.';

	/// en: '9. Intellectual Property'
	String get doc_rule_9_title => '9. Intellectual Property';

	/// en: 'All original assets, including stickers and UI elements, are the intellectual property of Amomimus.'
	String get doc_rule_9_desc => 'All original assets, including stickers and UI elements, are the intellectual property of Amomimus.';

	/// en: '10. Policy Updates'
	String get doc_rule_10_title => '10. Policy Updates';

	/// en: 'We reserve the right to update these terms. Continued use of the app constitutes acceptance of the new terms.'
	String get doc_rule_10_desc => 'We reserve the right to update these terms. Continued use of the app constitutes acceptance of the new terms.';

	/// en: 'Unpin from Memories'
	String get unpin_memories => 'Unpin from Memories';

	/// en: 'Pin to Memories'
	String get pin_memories => 'Pin to Memories';

	/// en: 'Report'
	String get report => 'Report';

	/// en: 'Show less'
	String get show_less => 'Show less';

	/// en: 'Show more'
	String get show_more => 'Show more';

	/// en: 'Post Detail'
	String get post_detail => 'Post Detail';

	/// en: 'Sticker Shop'
	String get sticker_shop => 'Sticker Shop';

	/// en: 'View'
	String get view => 'View';

	/// en: 'Buy'
	String get buy => 'Buy';

	/// en: 'Unlock your stickers here'
	String get unlock_stickers => 'Unlock your stickers here';

	/// en: 'Includes {count} exclusive items'
	String get includes_exclusive_items => 'Includes {count} exclusive items';

	/// en: '{count} {tier} stickers inside.'
	String get stickers_inside => '{count} {tier} stickers inside.';

	/// en: 'premium'
	String get premium => 'premium';

	/// en: 'You already own this batch.'
	String get already_own_batch => 'You already own this batch.';

	/// en: 'Not enough coins.'
	String get not_enough_coins => 'Not enough coins.';

	/// en: 'Emojis'
	String get emojis => 'Emojis';

	/// en: 'My Stickers'
	String get my_stickers => 'My Stickers';

	/// en: 'No stickers owned yet.'
	String get no_stickers_owned => 'No stickers owned yet.';

	/// en: 'Sticker'
	String get sticker => 'Sticker';

	/// en: 'Message deleted'
	String get message_deleted => 'Message deleted';

	/// en: 'My Sticker Stash'
	String get my_sticker_stash => 'My Sticker Stash';

	/// en: 'Your stash is empty.'
	String get stash_empty => 'Your stash is empty.';

	/// en: 'Visit the Sticker Shop to grab some packs!'
	String get visit_sticker_shop => 'Visit the Sticker Shop to grab some packs!';

	/// en: 'Stickers'
	String get stickers => 'Stickers';

	/// en: 'You own these stickers.'
	String get own_these_stickers => 'You own these stickers.';

	/// en: 'Your chosen Amomus: '
	String get chosen_amomus_prefix => 'Your chosen Amomus: ';

	/// en: 'Character not chosen yet!'
	String get character_not_chosen => 'Character not chosen yet!';

	/// en: 'Press back again to exit'
	String get press_back_again => 'Press back again to exit';

	/// en: 'EX-BLOCKED'
	String get ex_blocked => 'EX-BLOCKED';

	/// en: 'Blocked Users'
	String get blocked_users => 'Blocked Users';

	/// en: 'Previously Blocked (Ex-Blocked)'
	String get previously_blocked => 'Previously Blocked (Ex-Blocked)';

	/// en: 'You haven't blocked anyone.'
	String get no_blocked_users => 'You haven\'t blocked anyone.';

	/// en: 'SHUTTING DOWN...'
	String get splash_shutting_down => 'SHUTTING DOWN...';

	/// en: 'UNPLUG THE DYSTOPIA'
	String get splash_unplug => 'UNPLUG THE DYSTOPIA';

	/// en: 'RETURNING TO REALITY'
	String get splash_returning => 'RETURNING TO REALITY';

	/// en: 'NO SIGNAL'
	String get splash_no_signal => 'NO SIGNAL';

	/// en: 'STAND BY...'
	String get splash_stand_by => 'STAND BY...';

	/// en: 'EMBRACE THE NOISE'
	String get splash_embrace => 'EMBRACE THE NOISE';

	/// en: 'Smileys & Emotion'
	String get smileys_emotion => 'Smileys & Emotion';

	/// en: 'People & Body'
	String get people_body => 'People & Body';

	/// en: 'Animals & Nature'
	String get animals_nature => 'Animals & Nature';

	/// en: 'Food & Drink'
	String get food_drink => 'Food & Drink';

	/// en: 'No previous blocks.'
	String get no_previous_blocks => 'No previous blocks.';

	/// en: 'Unblock'
	String get unblock => 'Unblock';

	/// en: 'Block Again'
	String get block_again => 'Block Again';

	/// en: 'Error loading account data.'
	String get error_loading_account_data => 'Error loading account data.';

	/// en: 'Security & Authentication'
	String get security_auth => 'Security & Authentication';

	/// en: 'Favorite Character (2FA/Recovery)'
	String get favorite_character => 'Favorite Character (2FA/Recovery)';

	/// en: 'Edit (Max 1/day)'
	String get edit_max_1_day => 'Edit (Max 1/day)';

	/// en: 'Forget Passcode'
	String get forget_passcode => 'Forget Passcode';

	/// en: 'Use your favorite character to reset your passcode.'
	String get reset_passcode_hint => 'Use your favorite character to reset your passcode.';

	/// en: 'Reset Passcode'
	String get reset_passcode => 'Reset Passcode';

	/// en: 'Share'
	String get share => 'Share';

	/// en: 'Continue'
	String get continue_btn => 'Continue';

	/// en: 'Validation Form'
	String get validation_form => 'Validation Form';

	/// en: 'Registration Failed'
	String get email_already_registered_title => 'Registration Failed';

	/// en: 'This email is already registered. Would you like to log in instead?'
	String get email_already_registered_desc => 'This email is already registered. Would you like to log in instead?';

	/// en: 'Go to Login'
	String get go_to_login => 'Go to Login';
}

/// The flat map containing all translations for locale <en>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on Translations {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'app_doc' => 'App Documentation',
			'contact_dev' => 'Contact Developers',
			'language' => 'Language',
			'report_bug' => 'Report a Bug',
			'exit' => 'Exit Session',
			'center' => 'Amomimus Center',
			'support_queries' => 'For Help and Support Queries',
			'help_support' => 'HELP & SUPPORT',
			'public_name' => 'Public Name',
			'privacy_settings' => 'Privacy & Settings',
			'danger_zone' => 'Danger Zone',
			'delete_account_warning' => 'Deleting your account will permanently wipe all local session data, resonation histories, and saved settings. This action cannot be undone.',
			'privacy' => 'Privacy',
			'about' => 'About',
			'policy' => 'Policy',
			'options' => 'Options',
			'how_it_works' => 'How Amomimus Works',
			'report_bug_glitch' => 'Report a Bug / Glitch',
			'terms_of' => 'Terms of ',
			'privacy_rules_agreement' => 'Privacy & Rules Agreement',
			'privacy_rules_text' => 'Last updated: May 2026\n\n1. Keep It Ghostly\nYou\'re a ghost here, bud. No real names, no phone numbers, and definitely no leaking your ex\'s address or social media handles. We want this space to be completely detached from your real-world drama.\n\nIf you accidentally slip up and reveal your true identity or doxx someone else, don\'t expect a warning. We will scrub that post faster than you can blink, and your access might vanish along with it. Keep it 100% incognito.\n\n2. Don\'t Be a Total Jerk\nRanting? Cool. Crying? We got you. Venting about how much your job or life sucks is exactly why we built this app, so feel free to let off some steam without holding back.\n\nBut throwing straight-up hate speech, targeted harassment, or bullying someone who is already down? Nah, that\'s a fast pass to getting booted. There is a very clear line between venting your pain and just being a miserable troll.\n\n3. Zero Data Retention\nWe don\'t buy, sell, or even care about your personal data. What happens in Amomimus, stays in Amomimus. Your temporary sessions are encrypted and will be wiped clean periodically from our servers.\n\n4. No Commercial Spamming\nThis platform is made for human emotions, not for selling your crypto coins, promoting your online shop, or spamming affiliate links. Commercial ads without permission will result in an immediate hardware ban.\n\n5. Age Restriction\nUsers must be at least 18 years old to participate in this blind community. The contents shared here can be mature, heavy, and raw. Protect your own mental health before reading others\' rants.\n\n6. Content Ownership Disclaimer\nYou own the words you write, but by posting them here, you grant Amomimus a non-exclusive right to display them anonymously within the app interface. We will never claim your stories as our corporate property.\n\n7. Report and Moderation System\nEven ghosts have boundaries. If you find a post that violates our community safety guidelines, use the report feature immediately. Our automated system and moderators review flags 24/7.\n\n8. Illegal Activities Ban\nDo not use this app to plan, coordinate, or promote any form of illegal activities, physical violence, or real-world harm. We comply with digital safety regulations and will take strict action against violations.\n\n9. Application Analytics\nWe only collect anonymous technical logs (such as crash reports, device model, and system language) to ensure the app runs smoothly on your phone. None of these logs can be traced back to your real identity.\n\n10. Changes to the Terms\nAmomimus reserves the right to update these rules anytime to adapt to new laws or features. Continued use of the app after updates means you agree to follow the latest ghostly protocols.',
			'system_language' => 'Amomimus System Language:',
			'dob' => 'Date of Birth:',
			'dob_required' => '* Required â€” you must select your date of birth',
			'agreement_verified' => 'Agreement verified',
			'ready_to_verify' => 'Ready to verified our terms?',
			'age_warning' => 'You must be at least 18 years old to use Amomimus.',
			'accept_continue' => 'Accept & Continue',
			'select_birthday_first' => 'Select your birthday first',
			'accept_terms_first' => 'Accept the terms first',
			'mobile_app' => 'Amomimus Mobile App',
			'app_desc' => 'A secure and a room of anonymous venting platform designed for digital catharsis.',
			'create_your' => 'Create Your ',
			'anonymous_username_label' => 'ANONYMOUS USERNAME',
			'leave_blank_random' => 'Leave blank for a random name',
			'enter_username_hint' => 'Enter your username',
			'id_generator_title' => 'AMOMIMUS ID GENERATOR',
			'random_generate_id' => 'Random Generate ID:',
			'choose_avatar_title' => 'CHOOSE YOUR AMOMUS AVATAR',
			'incomplete_selection' => 'Incomplete Selection',
			'proceed' => 'Proceed',
			'choose_avatar_first' => 'Please choose your Amomus Avatar first!',
			'incomplete_selection_desc_1' => 'You haven\'t ',
			'incomplete_selection_desc_2' => '.\n\nYou won\'t be restricted, but you will not have your custom name displayed to you. The system will auto-generate a random one instead. Do you want to proceed?',
			'you_found_easter_egg' => 'You found the easter egg',
			'developer' => 'Developer:',
			'skip' => 'Skip',
			'welcome_to' => 'Welcome to ',
			'safe_space_desc' => 'A safe space to share your thoughts, ask questions, and connect with others.',
			'identity_hidden_desc_1' => 'Your real identity is hidden beneath an ',
			'identity_hidden_desc_2' => ' name.',
			'identity_protected_desc' => 'We ensure your identity is protected.\nChat freely without worrying about who is on the other side.',
			'intro_indicators' => 'Introducing Amomimus Indicators:',
			'neutral' => 'Neutral',
			'users_participate_normally' => ' users who participate normally.',
			'amoral' => 'Amoral',
			'users_nonchalant' => ' or nonchalant users to watch out for.',
			'toxic' => 'Toxic',
			'users_flagged' => ' users flagged by the community.',
			'safe_and' => 'Safe & ',
			'respectful' => 'Respectful',
			'value_privacy_desc' => 'We value privacy and kindness. Please follow our community rules while you explore.',
			'app_version' => 'App Version:',
			'share_to_chat' => 'Share to Chat',
			'create_post' => 'Create a Post',
			'whats_on_your_mind' => 'What\'s on your mind anonymously?',
			'send_post' => 'Send Post',
			'notifications' => 'Notifications',
			'no_notifications' => 'No notifications yet',
			'no_feeds' => 'No feeds available.',
			'comments' => 'Comments',
			'no_comments' => 'No comments yet. Be the first to comment!',
			'add_comment' => 'Add a comment...',
			'replying_to' => 'Replying to',
			'chat_this_amomim' => 'Chat this Amomim',
			'delete_post' => 'Delete this post',
			'hide_feed' => 'Hide this feed',
			'report_amomim' => 'Report this Amomim',
			'resonated' => 'Resonated',
			'resonates' => 'Resonates',
			'chat_req_pending' => 'Chat Request Pending...',
			'indicator_noise_limit' => 'Your Amomimus Indicator is NOISE. Chat requests are prohibited.',
			'ghost_limit_reached' => 'GHOST Indicator limit reached: 7 chat requests per day.',
			'initiate_chat' => 'Initiate Chat',
			'confirm_chat' => 'Are you sure you want to chat with the author of this post?\n\nThey will see you as ',
			'cancel' => 'Cancel',
			'send_request' => 'Send Request',
			'chat_req_sent' => 'Chat Request Sent!',
			'feed_hidden' => 'Feed hidden.',
			'bio' => 'Bio',
			'no_bio_yet' => 'No bio yet',
			'write_bio' => 'Write your bio...',
			'select_date' => 'Select Date',
			'ok' => 'OK',
			'error_format' => 'Invalid format',
			'error_invalid' => 'Invalid date',
			'notif_resonate' => 'resonated with your post',
			'notif_comment' => 'commented on your post',
			'notif_reply' => 'replied to your comment',
			'just_now' => 'Just now',
			'bio_updated' => 'Bio updated!',
			'coins_redemption' => 'Coins Redemption',
			'redeemed_100_coins' => 'Redeemed 100 Coins!',
			'vault_merit' => 'Vault & Merit',
			'my_coins' => 'My Coins',
			'owned' => 'Owned',
			'sticker_stash' => 'Sticker Stash',
			'amomimus_indicators' => 'Amomimus Indicators:',
			'recent_resonates' => 'Recent Resonates',
			'see_all' => 'See All',
			'no_recent_resonates' => 'No recent resonates.',
			'all_resonates' => 'All Resonates',
			'no_resonates_yet' => 'No resonates yet',
			'delete_post_title' => 'Delete Post',
			'delete_post_confirm' => 'Are you sure you want to delete this post? This will remove it from the feed.',
			'delete_account' => 'Delete Account',
			'delete' => 'Delete',
			'profile_locked' => 'Profile Locked',
			'locked_desc' => 'You need to establish a chat connection with this user to view their full profile.',
			'profile' => 'Profile',
			'no_active_user' => 'No active user.',
			'incoming_requests' => 'Incoming Requests',
			'no_incoming_requests' => 'No incoming requests',
			'chat_req_accepted' => 'Chat request accepted!',
			'messages' => 'Messages',
			'amomus_list' => 'Amomus List',
			'switch_account' => 'Switch Account',
			'no_accounts_registered' => 'No accounts registered yet.',
			'chat_requests' => 'Chat Requests',
			'chat_request_title' => 'Chat Request',
			'chat_request_desc1' => 'Sending a chat request to this amomimus will reveal your registered username "',
			'chat_request_desc2' => '" instead of your feed name "',
			'chat_request_desc3' => '".\n\nThey will also be able to see your profile if they accept.',
			'delete_chat_title' => 'Delete Chat',
			'delete_chat_confirm_prefix' => 'Are you sure you want to delete this chat with ',
			'delete_chat_confirm_suffix' => '?',
			'chat_deleted_prefix' => 'Chat with ',
			'chat_deleted_suffix' => ' deleted',
			'memories' => 'Memories',
			'no_memories_pinned' => 'No memories pinned yet.',
			'delete_chat_room_confirm' => 'Are you sure you want to delete this chat?',
			'pin_limit_error' => 'You can only pin up to 9 memories. Unpin one first!',
			'write_message' => 'Write message...',
			'reply' => 'Reply',
			'doc_title' => 'App Documentation',
			'doc_category_legal' => 'Legal & Privacy Policy',
			'doc_rule_1_title' => '1. Data Collection',
			'doc_rule_1_desc' => 'We collect minimal data necessary for core features. Your anonymous identifier is not linked to your personal identity.',
			'doc_rule_2_title' => '2. End-to-End Encryption',
			'doc_rule_2_desc' => 'All chat messages are end-to-end encrypted. We cannot read your private messages.',
			'doc_rule_3_title' => '3. Session Data',
			'doc_rule_3_desc' => 'Local session data is stored securely on your device. Clearing your app data will permanently erase your local history.',
			'doc_rule_4_title' => '4. Third-Party Services',
			'doc_rule_4_desc' => 'We do not sell or share your data with third parties. Any external integrations are strictly for operational purposes.',
			'doc_rule_5_title' => '5. User Content Liability',
			'doc_rule_5_desc' => 'You are solely responsible for the content you post. Amomimus is not liable for user-generated content.',
			'doc_rule_6_title' => '6. Anonymity Guarantee',
			'doc_rule_6_desc' => 'Your public interactions remain anonymous unless you explicitly choose to reveal your identity via a chat request.',
			'doc_rule_7_title' => '7. Account Deletion',
			'doc_rule_7_desc' => 'You have the right to delete your account at any time. This action is irreversible and wipes all associated records.',
			'doc_rule_8_title' => '8. Harassment & Abuse',
			'doc_rule_8_desc' => 'We maintain a strict zero-tolerance policy against harassment. Violators will be permanently banned.',
			'doc_rule_9_title' => '9. Intellectual Property',
			'doc_rule_9_desc' => 'All original assets, including stickers and UI elements, are the intellectual property of Amomimus.',
			'doc_rule_10_title' => '10. Policy Updates',
			'doc_rule_10_desc' => 'We reserve the right to update these terms. Continued use of the app constitutes acceptance of the new terms.',
			'unpin_memories' => 'Unpin from Memories',
			'pin_memories' => 'Pin to Memories',
			'report' => 'Report',
			'show_less' => 'Show less',
			'show_more' => 'Show more',
			'post_detail' => 'Post Detail',
			'sticker_shop' => 'Sticker Shop',
			'view' => 'View',
			'buy' => 'Buy',
			'unlock_stickers' => 'Unlock your stickers here',
			'includes_exclusive_items' => 'Includes {count} exclusive items',
			'stickers_inside' => '{count} {tier} stickers inside.',
			'premium' => 'premium',
			'already_own_batch' => 'You already own this batch.',
			'not_enough_coins' => 'Not enough coins.',
			'emojis' => 'Emojis',
			'my_stickers' => 'My Stickers',
			'no_stickers_owned' => 'No stickers owned yet.',
			'sticker' => 'Sticker',
			'message_deleted' => 'Message deleted',
			'my_sticker_stash' => 'My Sticker Stash',
			'stash_empty' => 'Your stash is empty.',
			'visit_sticker_shop' => 'Visit the Sticker Shop to grab some packs!',
			'stickers' => 'Stickers',
			'own_these_stickers' => 'You own these stickers.',
			'chosen_amomus_prefix' => 'Your chosen Amomus: ',
			'character_not_chosen' => 'Character not chosen yet!',
			'press_back_again' => 'Press back again to exit',
			'ex_blocked' => 'EX-BLOCKED',
			'blocked_users' => 'Blocked Users',
			'previously_blocked' => 'Previously Blocked (Ex-Blocked)',
			'no_blocked_users' => 'You haven\'t blocked anyone.',
			'splash_shutting_down' => 'SHUTTING DOWN...',
			'splash_unplug' => 'UNPLUG THE DYSTOPIA',
			'splash_returning' => 'RETURNING TO REALITY',
			'splash_no_signal' => 'NO SIGNAL',
			'splash_stand_by' => 'STAND BY...',
			'splash_embrace' => 'EMBRACE THE NOISE',
			'smileys_emotion' => 'Smileys & Emotion',
			'people_body' => 'People & Body',
			'animals_nature' => 'Animals & Nature',
			'food_drink' => 'Food & Drink',
			'no_previous_blocks' => 'No previous blocks.',
			'unblock' => 'Unblock',
			'block_again' => 'Block Again',
			'error_loading_account_data' => 'Error loading account data.',
			'security_auth' => 'Security & Authentication',
			'favorite_character' => 'Favorite Character (2FA/Recovery)',
			'edit_max_1_day' => 'Edit (Max 1/day)',
			'forget_passcode' => 'Forget Passcode',
			'reset_passcode_hint' => 'Use your favorite character to reset your passcode.',
			'reset_passcode' => 'Reset Passcode',
			'share' => 'Share',
			'continue_btn' => 'Continue',
			'validation_form' => 'Validation Form',
			'email_already_registered_title' => 'Registration Failed',
			'email_already_registered_desc' => 'This email is already registered. Would you like to log in instead?',
			'go_to_login' => 'Go to Login',
			_ => null,
		};
	}
}
