///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import
// dart format off

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:slang/generated.dart';
import 'strings.g.dart';

// Path: <root>
class TranslationsTm extends Translations with BaseTranslations<AppLocale, Translations> {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	TranslationsTm({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.tm,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ),
		  super(cardinalResolver: cardinalResolver, ordinalResolver: ordinalResolver) {
		super.$meta.setFlatMapFunction($meta.getTranslation); // copy base translations to super.$meta
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <tm>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	@override dynamic operator[](String key) => $meta.getTranslation(key) ?? super.$meta.getTranslation(key);

	late final TranslationsTm _root = this; // ignore: unused_field

	@override 
	TranslationsTm $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => TranslationsTm(meta: meta ?? this.$meta);

	// Translations
	@override String get app_doc => 'Faal Kel';
	@override String get contact_dev => 'Summon Bormahu';
	@override String get language => 'Zul';
	@override String get report_bug => 'Condemn a Viik';
	@override String get exit => 'Daal';
	@override String get center => 'Monahven Sanctum';
	@override String get support_queries => 'For Pruzah Aak';
	@override String get help_support => 'AAK & VOLAAN';
	@override String get public_name => 'Joore Title';
	@override String get privacy_settings => 'Shadow Rites';
	@override String get danger_zone => 'Vokul Domain';
	@override String get delete_account_warning => 'Banishing your vessel will cleanse all vahrukiv and echoes of your Thu\'um. This doom cannot be unmade, joor.';
	@override String get privacy => 'Vokul';
	@override String get about => 'Vahrukiv';
	@override String get policy => 'Rotmulaag';
	@override String get options => 'Rites';
	@override String get how_it_works => 'How This Thu\'um Works';
	@override String get report_bug_glitch => 'Report a Viik';
	@override String get terms_of => 'Covenants of ';
	@override String get privacy_rules_agreement => 'Pact of the Voice';
	@override String get privacy_rules_text => 'Last reforged: May 2026\n\n1. Faal Vokul\nYou are a rah here, joor. No real names, no farspeaker ciphers, and absolutely no leaking your ex\'s dwelling. We want this void to be completely severed from your mortal theatrics.\n\nIf you accidentally slip up and reveal your true visage or doxx another, do not expect a warning. We will purge that Thu\'um faster than you can blink, and your access might vanish with it. Keep it 100% unseen.\n\n2. Do Not Be A Wretched Falmer\nRanting? Good. Crying? We hear you. Lamenting how much your labor sucks is exactly why we forged this Kel, so feel free to release your Su\'um without holding back.\n\nBut throwing straight-up hate speech, targeted harassment, or bullying? No, that is a swift carriage to exile. There is a distinct boundary between venting your Krosis and just being a toxic troll.\n\n3. No Hermaeus Mora Hoarding\nWe do not buy, sell, or even care about your private lore. What happens in Amomimus, stays in Amomimus. Your sessions are warded and will be wiped clean from our archives.\n\n4. No Khajiit Caravans\nThis stage is for mortal passions, not for hawking your wares, boasting your bazaar, or bellowing merchant pacts. Selling here will get you exiled.\n\n5. Winters Survived\nJoore must be at least EIGHTEEN winters old to partake in this fellowship. The Thu\'um here can be mature, heavy, and raw. Shield your mind.\n\n6. Ownership of the Voice\nYou own the words you scribe, but by nailing them here, you grant Amomimus a shared privilege to display them namelessly across the realm.\n\n7. The Guards\' Watch\nEven phantoms have borders. If you discover a Thu\'um that breaks our laws, use the condemn tool. Our Golem sentinels watch day and night.\n\n8. Dark Brotherhood Ban\nDo not employ this scroll to scheme, muster, or incite any real-world bloodshed or ruin. We obey mortal laws and will strike down transgressions.\n\n9. Scrying the Aether\nWe gather only nameless arcane dust like device shape and realm zul to make sure the scroll flows smoothly. None of it can be tracked to your true face.\n\n10. Shiftings of the Rotmulaag\nWe hold the privilege to renew these decrees whenever the winds of magic shift. Continued use means you bow to the new rituals.';
	@override String get system_language => 'Realm\'s Zul:';
	@override String get dob => 'Day of Naming:';
	@override String get dob_required => '* Required — you must select your day of naming, joor';
	@override String get agreement_verified => 'Pact Verified';
	@override String get ready_to_verify => 'Ready to verify the Rotmulaag?';
	@override String get age_warning => 'You must have survived 18 winters to wield this scroll.';
	@override String get accept_continue => 'Swear Oath & Walk';
	@override String get select_birthday_first => 'Select your birth date first';
	@override String get accept_terms_first => 'Swear the Oath first, joor';
	@override String get mobile_app => 'Pocket Kel';
	@override String get app_desc => 'A secure sanctuary to unleash your Thu\'um into the void.';
	@override String get share_to_chat => 'Aak Hifrah';
	@override String get create_your => 'Forge Your ';
	@override String get anonymous_username_label => 'FACELESS COWL';
	@override String get leave_blank_random => 'Leave blank for a blessing of Akatosh';
	@override String get enter_username_hint => 'Engrave your moniker';
	@override String get id_generator_title => 'DWEMER CONSTRUCT';
	@override String get random_generate_id => 'Random Forge ID:';
	@override String get choose_avatar_title => 'CHOOSE YOUR VISAGE';
	@override String get incomplete_selection => 'Unfinished Ritual';
	@override String get proceed => 'Venture Forth';
	@override String get choose_avatar_first => 'Choose your Visage first, by Ysmir!';
	@override String get incomplete_selection_desc_1 => 'You haven\'t ';
	@override String get incomplete_selection_desc_2 => '.\n\nYou won\'t be restricted, but you will not have your custom title. The realm will auto-generate a random one. Do you desire to proceed?';
	@override String get you_found_easter_egg => 'You found a sweetroll!';
	@override String get developer => 'Moth Priest:';
	@override String get skip => 'Pass';
	@override String get welcome_to => 'Pruzah vand to ';
	@override String get safe_space_desc => 'A safe void to cast your Thu\'um and connect with other joore.';
	@override String get identity_hidden_desc_1 => 'Your true face is hidden beneath a ';
	@override String get identity_hidden_desc_2 => ' title.';
	@override String get identity_protected_desc => 'We make sure your visage is protected.\nSpeak freely without the Guards tracking you.';
	@override String get intro_indicators => 'Behold the Auras:';
	@override String get neutral => 'Citizen';
	@override String get users_participate_normally => ' mortals who partake normally.';
	@override String get amoral => 'Skooma Drinker';
	@override String get users_nonchalant => ' chaotic souls to watch out for.';
	@override String get toxic => 'Bandit';
	@override String get users_flagged => ' outlaws flagged by the realm.';
	@override String get safe_and => 'Guarded & ';
	@override String get respectful => 'Honorable';
	@override String get value_privacy_desc => 'We value the Greybeards\' silence. Respect the decrees.';
	@override String get app_version => 'Scroll Epoch:';
	@override String get create_post => 'Cast a Thu\'um';
	@override String get whats_on_your_mind => 'What troubles your mind, joor?';
	@override String get send_post => 'Unleash Thu\'um';
	@override String get notifications => 'Omens';
	@override String get no_notifications => 'No omens yet, joor.';
	@override String get no_feeds => 'The board is barren.';
	@override String get comments => 'Rot';
	@override String get no_comments => 'Quiet as a grave. Be the first to whisper!';
	@override String get add_comment => 'Whisper in the wind...';
	@override String get replying_to => 'Shouting back at';
	@override String get chat_this_amomim => 'Hifrah with this soul';
	@override String get delete_post => 'Banish this Thu\'um';
	@override String get hide_feed => 'Hide this board';
	@override String get report_amomim => 'Condemn this Joor';
	@override String get resonated => 'Your Thu\'um resonated';
	@override String get resonates => 'Echoes';
	@override String get chat_req_pending => 'Courier Pending...';
	@override String get indicator_noise_limit => 'Your Aura is NOISE. Couriers are forbidden.';
	@override String get ghost_limit_reached => 'Magicka depleted: Only 7 Couriers per day.';
	@override String get initiate_chat => 'Summon Courier';
	@override String get confirm_chat => 'Are you sure you desire to parley with this soul?\n\nThey will see you as ';
	@override String get cancel => 'Sheathe Weapon';
	@override String get send_request => 'Dispatch Courier';
	@override String get chat_req_sent => 'Courier dispatched!';
	@override String get feed_hidden => 'Illusion cast. Board hidden.';
	@override String get bio => 'Su\'um';
	@override String get no_bio_yet => 'No Su\'um yet';
	@override String get write_bio => 'Scribe your Su\'um...';
	@override String get select_date => 'Consult the Stars';
	@override String get ok => 'GEH';
	@override String get error_format => 'Krosis, invalid format';
	@override String get error_invalid => 'Krosis, invalid date';
	@override String get notif_resonate => 'felt the power of your Thu\'um';
	@override String get notif_comment => 'left a rot on your Thu\'um';
	@override String get notif_reply => 'retorted to your rot';
	@override String get just_now => 'A heartbeat ago';
	@override String get bio_updated => 'Su\'um reforged!';
	@override String get coins_redemption => 'Faraan Exchange';
	@override String get redeemed_100_coins => 'Redeemed 100 Faraan!';
	@override String get vault_merit => 'Strongbox & Mulaag';
	@override String get my_coins => 'My Faraan';
	@override String get owned => 'Owned';
	@override String get sticker_stash => 'Rune Satchel';
	@override String get amomimus_indicators => 'Auras of the Realm:';
	@override String get recent_resonates => 'Recent Echoes';
	@override String get see_all => 'Behold All';
	@override String get no_recent_resonates => 'The mountains are silent.';
	@override String get all_resonates => 'All Echoes';
	@override String get no_resonates_yet => 'No echoes in the caverns yet';
	@override String get delete_post_title => 'Obliterate Thu\'um';
	@override String get delete_post_confirm => 'Cast this shout into the Void? It shall vanish forever.';
	@override String get delete_account => 'Banish Vessel';
	@override String get delete => 'Annihilate';
	@override String get profile_locked => 'Visage Obscured';
	@override String get locked_desc => 'You must exchange Couriers with this wanderer to pierce their Illusion.';
	@override String get profile => 'Visage';
	@override String get no_active_user => 'No soul walks here.';
	@override String get incoming_requests => 'Approaching Couriers';
	@override String get no_incoming_requests => 'The roads are empty.';
	@override String get chat_req_accepted => 'Courier accepted!';
	@override String get messages => 'Rot';
	@override String get amomus_list => 'Fellowship Roster';
	@override String get switch_account => 'Switch Vessel';
	@override String get no_accounts_registered => 'No other vessels bound to your soul.';
	@override String get chat_requests => 'Courier Requests';
	@override String get chat_request_title => 'A Courier Approaches';
	@override String get chat_request_desc1 => 'Sending a courier to this wanderer will reveal your alias "';
	@override String get chat_request_desc2 => '" instead of your shadowed name "';
	@override String get chat_request_desc3 => '".\n\nIf they accept, they shall gaze upon your true Visage.';
	@override String get delete_chat_title => 'Burn the Missives';
	@override String get delete_chat_confirm_prefix => 'Are you sure you want to burn the letters shared with ';
	@override String get delete_chat_confirm_suffix => '?';
	@override String get chat_deleted_prefix => 'Missives with ';
	@override String get chat_deleted_suffix => ' turned to ash.';
	@override String get memories => 'Vahrukiv';
	@override String get no_memories_pinned => 'No Vahrukiv pinned yet.';
	@override String get delete_chat_room_confirm => 'Cast this parley into Oblivion?';
	@override String get pin_limit_error => 'Your inventory is over encumbered! Limit 9 items. Unpin one first!';
	@override String get write_message => 'Scribe rot...';
	@override String get reply => 'Retort';
	@override String get doc_title => 'Oghma Infinium';
	@override String get doc_category_legal => 'Imperial Law & Shadows';
	@override String get doc_rule_1_title => '1. Scrying Limits';
	@override String get doc_rule_1_desc => 'We scry only the magicka needed to keep the realm afloat. Your soul is hidden.';
	@override String get doc_rule_2_title => '2. Wards of Encryption';
	@override String get doc_rule_2_desc => 'Your missives are locked with Master-level wards. We cannot read them.';
	@override String get doc_rule_3_title => '3. The Local Strongbox';
	@override String get doc_rule_3_desc => 'Your lore is kept on your device. Cleansing your scroll wipes your local chronicles.';
	@override String get doc_rule_4_title => '4. No Khajiit Caravans';
	@override String get doc_rule_4_desc => 'We do not sell your soul to merchants. External guilds are only to keep the torches lit.';
	@override String get doc_rule_5_title => '5. The Bard\'s Burden';
	@override String get doc_rule_5_desc => 'You are solely responsible for your Thu\'um. We take no blame for your voice.';
	@override String get doc_rule_6_title => '6. The Cowl\'s Promise';
	@override String get doc_rule_6_desc => 'You are a shadow, unless you choose to drop the cowl and summon a Courier.';
	@override String get doc_rule_7_title => '7. Soul Severance';
	@override String get doc_rule_7_desc => 'You may sever your soul from the realm at will. This is irreversible.';
	@override String get doc_rule_8_title => '8. No Dark Brotherhood';
	@override String get doc_rule_8_desc => 'Torment is forbidden by the Jarl. Violators face the Headsman\'s Axe.';
	@override String get doc_rule_9_title => '9. Relics of the Realm';
	@override String get doc_rule_9_desc => 'All Runes and logic of this realm belong to the Architects of Amomimus.';
	@override String get doc_rule_10_title => '10. The Elder Council\'s Whim';
	@override String get doc_rule_10_desc => 'The Architects may rewrite these laws. By walking the roads, you obey the new edicts.';
	@override String get unpin_memories => 'Unbind Vahrukiv';
	@override String get pin_memories => 'Bind Vahrukiv';
	@override String get report => 'Call Guards';
	@override String get show_less => 'Read Less';
	@override String get show_more => 'Read More';
	@override String get post_detail => 'Tale Etched in Stone';
	@override String get sticker_shop => 'Belethor\'s Wares';
	@override String get view => 'Inspect';
	@override String get buy => 'Barter Faraan';
	@override String get unlock_stickers => 'Break the seals on new Runes here';
	@override String get includes_exclusive_items => 'Holds {count} rare artifacts';
	@override String get stickers_inside => '{count} {tier} enchanted runes inside.';
	@override String get premium => 'Daedric Premium';
	@override String get already_own_batch => 'You already have this artifact.';
	@override String get not_enough_coins => 'You don\'t have enough Faraan.';
	@override String get emojis => 'War Paints';
	@override String get my_stickers => 'My Runes';
	@override String get no_stickers_owned => 'Your satchel holds no Runes.';
	@override String get sticker => 'Rune';
	@override String get message_deleted => 'Rot burned';
	@override String get my_sticker_stash => 'My Rune Satchel';
	@override String get stash_empty => 'Your satchel is empty.';
	@override String get visit_sticker_shop => 'Visit Belethor\'s Wares to acquire Rune packs!';
	@override String get stickers => 'Runes';
	@override String get own_these_stickers => 'These enchantments are yours.';
	@override String get chosen_amomus_prefix => 'Your Patron Divine: ';
	@override String get character_not_chosen => 'You have no Patron yet!';
	@override String get press_back_again => 'Press back again to exit Skyrim';
	@override String get ex_blocked => 'OUTLAW';
	@override String get blocked_users => 'DUNGEON PRISONERS';
	@override String get previously_blocked => 'FORMER INMATES OUTLAWS';
	@override String get no_blocked_users => 'The dungeons are empty.';
	@override String get splash_shutting_down => 'OBLIVION CALLS...';
	@override String get splash_unplug => 'SEVERING MAGICKA TETHERS';
	@override String get splash_returning => 'RETURNING TO MUNDUS';
	@override String get splash_no_signal => 'THE ELDER SCROLL IS BLIND';
	@override String get splash_stand_by => 'BY THE NINE, TARRY...';
	@override String get splash_embrace => 'EMBRACE THE THU\'UM';
	@override String get smileys_emotion => 'Visages & Humors';
	@override String get people_body => 'Mer & Flesh';
	@override String get animals_nature => 'Creatures of Nirn';
	@override String get food_drink => 'Sweetrolls & Ale';
	@override String get no_previous_blocks => 'No pardoned souls.';
	@override String get unblock => 'Grant Pardon';
	@override String get block_again => 'Throw in Dungeon';
	@override String get error_loading_account_data => 'Krosis, the Scroll is corrupted!';
	@override String get security_auth => 'Wards & Locks';
	@override String get favorite_character => 'Patron Deity Safe Word';
	@override String get edit_max_1_day => 'Alter once per day';
	@override String get forget_passcode => 'Forgot the Dragon Claw Code?';
	@override String get reset_passcode_hint => 'Invoke your Patron Deity to unlock the door.';
	@override String get reset_passcode => 'Restore Claw Code';
	@override String get email_already_registered_title => 'Ritual Failed';
	@override String get email_already_registered_desc => 'This soul is already bound. Doth thou wish to awaken it instead?';
	@override String get go_to_login => 'Awaken';
}

/// The flat map containing all translations for locale <tm>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on TranslationsTm {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'app_doc' => 'Faal Kel',
			'contact_dev' => 'Summon Bormahu',
			'language' => 'Zul',
			'report_bug' => 'Condemn a Viik',
			'exit' => 'Daal',
			'center' => 'Monahven Sanctum',
			'support_queries' => 'For Pruzah Aak',
			'help_support' => 'AAK & VOLAAN',
			'public_name' => 'Joore Title',
			'privacy_settings' => 'Shadow Rites',
			'danger_zone' => 'Vokul Domain',
			'delete_account_warning' => 'Banishing your vessel will cleanse all vahrukiv and echoes of your Thu\'um. This doom cannot be unmade, joor.',
			'privacy' => 'Vokul',
			'about' => 'Vahrukiv',
			'policy' => 'Rotmulaag',
			'options' => 'Rites',
			'how_it_works' => 'How This Thu\'um Works',
			'report_bug_glitch' => 'Report a Viik',
			'terms_of' => 'Covenants of ',
			'privacy_rules_agreement' => 'Pact of the Voice',
			'privacy_rules_text' => 'Last reforged: May 2026\n\n1. Faal Vokul\nYou are a rah here, joor. No real names, no farspeaker ciphers, and absolutely no leaking your ex\'s dwelling. We want this void to be completely severed from your mortal theatrics.\n\nIf you accidentally slip up and reveal your true visage or doxx another, do not expect a warning. We will purge that Thu\'um faster than you can blink, and your access might vanish with it. Keep it 100% unseen.\n\n2. Do Not Be A Wretched Falmer\nRanting? Good. Crying? We hear you. Lamenting how much your labor sucks is exactly why we forged this Kel, so feel free to release your Su\'um without holding back.\n\nBut throwing straight-up hate speech, targeted harassment, or bullying? No, that is a swift carriage to exile. There is a distinct boundary between venting your Krosis and just being a toxic troll.\n\n3. No Hermaeus Mora Hoarding\nWe do not buy, sell, or even care about your private lore. What happens in Amomimus, stays in Amomimus. Your sessions are warded and will be wiped clean from our archives.\n\n4. No Khajiit Caravans\nThis stage is for mortal passions, not for hawking your wares, boasting your bazaar, or bellowing merchant pacts. Selling here will get you exiled.\n\n5. Winters Survived\nJoore must be at least EIGHTEEN winters old to partake in this fellowship. The Thu\'um here can be mature, heavy, and raw. Shield your mind.\n\n6. Ownership of the Voice\nYou own the words you scribe, but by nailing them here, you grant Amomimus a shared privilege to display them namelessly across the realm.\n\n7. The Guards\' Watch\nEven phantoms have borders. If you discover a Thu\'um that breaks our laws, use the condemn tool. Our Golem sentinels watch day and night.\n\n8. Dark Brotherhood Ban\nDo not employ this scroll to scheme, muster, or incite any real-world bloodshed or ruin. We obey mortal laws and will strike down transgressions.\n\n9. Scrying the Aether\nWe gather only nameless arcane dust like device shape and realm zul to make sure the scroll flows smoothly. None of it can be tracked to your true face.\n\n10. Shiftings of the Rotmulaag\nWe hold the privilege to renew these decrees whenever the winds of magic shift. Continued use means you bow to the new rituals.',
			'system_language' => 'Realm\'s Zul:',
			'dob' => 'Day of Naming:',
			'dob_required' => '* Required — you must select your day of naming, joor',
			'agreement_verified' => 'Pact Verified',
			'ready_to_verify' => 'Ready to verify the Rotmulaag?',
			'age_warning' => 'You must have survived 18 winters to wield this scroll.',
			'accept_continue' => 'Swear Oath & Walk',
			'select_birthday_first' => 'Select your birth date first',
			'accept_terms_first' => 'Swear the Oath first, joor',
			'mobile_app' => 'Pocket Kel',
			'app_desc' => 'A secure sanctuary to unleash your Thu\'um into the void.',
			'share_to_chat' => 'Aak Hifrah',
			'create_your' => 'Forge Your ',
			'anonymous_username_label' => 'FACELESS COWL',
			'leave_blank_random' => 'Leave blank for a blessing of Akatosh',
			'enter_username_hint' => 'Engrave your moniker',
			'id_generator_title' => 'DWEMER CONSTRUCT',
			'random_generate_id' => 'Random Forge ID:',
			'choose_avatar_title' => 'CHOOSE YOUR VISAGE',
			'incomplete_selection' => 'Unfinished Ritual',
			'proceed' => 'Venture Forth',
			'choose_avatar_first' => 'Choose your Visage first, by Ysmir!',
			'incomplete_selection_desc_1' => 'You haven\'t ',
			'incomplete_selection_desc_2' => '.\n\nYou won\'t be restricted, but you will not have your custom title. The realm will auto-generate a random one. Do you desire to proceed?',
			'you_found_easter_egg' => 'You found a sweetroll!',
			'developer' => 'Moth Priest:',
			'skip' => 'Pass',
			'welcome_to' => 'Pruzah vand to ',
			'safe_space_desc' => 'A safe void to cast your Thu\'um and connect with other joore.',
			'identity_hidden_desc_1' => 'Your true face is hidden beneath a ',
			'identity_hidden_desc_2' => ' title.',
			'identity_protected_desc' => 'We make sure your visage is protected.\nSpeak freely without the Guards tracking you.',
			'intro_indicators' => 'Behold the Auras:',
			'neutral' => 'Citizen',
			'users_participate_normally' => ' mortals who partake normally.',
			'amoral' => 'Skooma Drinker',
			'users_nonchalant' => ' chaotic souls to watch out for.',
			'toxic' => 'Bandit',
			'users_flagged' => ' outlaws flagged by the realm.',
			'safe_and' => 'Guarded & ',
			'respectful' => 'Honorable',
			'value_privacy_desc' => 'We value the Greybeards\' silence. Respect the decrees.',
			'app_version' => 'Scroll Epoch:',
			'create_post' => 'Cast a Thu\'um',
			'whats_on_your_mind' => 'What troubles your mind, joor?',
			'send_post' => 'Unleash Thu\'um',
			'notifications' => 'Omens',
			'no_notifications' => 'No omens yet, joor.',
			'no_feeds' => 'The board is barren.',
			'comments' => 'Rot',
			'no_comments' => 'Quiet as a grave. Be the first to whisper!',
			'add_comment' => 'Whisper in the wind...',
			'replying_to' => 'Shouting back at',
			'chat_this_amomim' => 'Hifrah with this soul',
			'delete_post' => 'Banish this Thu\'um',
			'hide_feed' => 'Hide this board',
			'report_amomim' => 'Condemn this Joor',
			'resonated' => 'Your Thu\'um resonated',
			'resonates' => 'Echoes',
			'chat_req_pending' => 'Courier Pending...',
			'indicator_noise_limit' => 'Your Aura is NOISE. Couriers are forbidden.',
			'ghost_limit_reached' => 'Magicka depleted: Only 7 Couriers per day.',
			'initiate_chat' => 'Summon Courier',
			'confirm_chat' => 'Are you sure you desire to parley with this soul?\n\nThey will see you as ',
			'cancel' => 'Sheathe Weapon',
			'send_request' => 'Dispatch Courier',
			'chat_req_sent' => 'Courier dispatched!',
			'feed_hidden' => 'Illusion cast. Board hidden.',
			'bio' => 'Su\'um',
			'no_bio_yet' => 'No Su\'um yet',
			'write_bio' => 'Scribe your Su\'um...',
			'select_date' => 'Consult the Stars',
			'ok' => 'GEH',
			'error_format' => 'Krosis, invalid format',
			'error_invalid' => 'Krosis, invalid date',
			'notif_resonate' => 'felt the power of your Thu\'um',
			'notif_comment' => 'left a rot on your Thu\'um',
			'notif_reply' => 'retorted to your rot',
			'just_now' => 'A heartbeat ago',
			'bio_updated' => 'Su\'um reforged!',
			'coins_redemption' => 'Faraan Exchange',
			'redeemed_100_coins' => 'Redeemed 100 Faraan!',
			'vault_merit' => 'Strongbox & Mulaag',
			'my_coins' => 'My Faraan',
			'owned' => 'Owned',
			'sticker_stash' => 'Rune Satchel',
			'amomimus_indicators' => 'Auras of the Realm:',
			'recent_resonates' => 'Recent Echoes',
			'see_all' => 'Behold All',
			'no_recent_resonates' => 'The mountains are silent.',
			'all_resonates' => 'All Echoes',
			'no_resonates_yet' => 'No echoes in the caverns yet',
			'delete_post_title' => 'Obliterate Thu\'um',
			'delete_post_confirm' => 'Cast this shout into the Void? It shall vanish forever.',
			'delete_account' => 'Banish Vessel',
			'delete' => 'Annihilate',
			'profile_locked' => 'Visage Obscured',
			'locked_desc' => 'You must exchange Couriers with this wanderer to pierce their Illusion.',
			'profile' => 'Visage',
			'no_active_user' => 'No soul walks here.',
			'incoming_requests' => 'Approaching Couriers',
			'no_incoming_requests' => 'The roads are empty.',
			'chat_req_accepted' => 'Courier accepted!',
			'messages' => 'Rot',
			'amomus_list' => 'Fellowship Roster',
			'switch_account' => 'Switch Vessel',
			'no_accounts_registered' => 'No other vessels bound to your soul.',
			'chat_requests' => 'Courier Requests',
			'chat_request_title' => 'A Courier Approaches',
			'chat_request_desc1' => 'Sending a courier to this wanderer will reveal your alias "',
			'chat_request_desc2' => '" instead of your shadowed name "',
			'chat_request_desc3' => '".\n\nIf they accept, they shall gaze upon your true Visage.',
			'delete_chat_title' => 'Burn the Missives',
			'delete_chat_confirm_prefix' => 'Are you sure you want to burn the letters shared with ',
			'delete_chat_confirm_suffix' => '?',
			'chat_deleted_prefix' => 'Missives with ',
			'chat_deleted_suffix' => ' turned to ash.',
			'memories' => 'Vahrukiv',
			'no_memories_pinned' => 'No Vahrukiv pinned yet.',
			'delete_chat_room_confirm' => 'Cast this parley into Oblivion?',
			'pin_limit_error' => 'Your inventory is over encumbered! Limit 9 items. Unpin one first!',
			'write_message' => 'Scribe rot...',
			'reply' => 'Retort',
			'doc_title' => 'Oghma Infinium',
			'doc_category_legal' => 'Imperial Law & Shadows',
			'doc_rule_1_title' => '1. Scrying Limits',
			'doc_rule_1_desc' => 'We scry only the magicka needed to keep the realm afloat. Your soul is hidden.',
			'doc_rule_2_title' => '2. Wards of Encryption',
			'doc_rule_2_desc' => 'Your missives are locked with Master-level wards. We cannot read them.',
			'doc_rule_3_title' => '3. The Local Strongbox',
			'doc_rule_3_desc' => 'Your lore is kept on your device. Cleansing your scroll wipes your local chronicles.',
			'doc_rule_4_title' => '4. No Khajiit Caravans',
			'doc_rule_4_desc' => 'We do not sell your soul to merchants. External guilds are only to keep the torches lit.',
			'doc_rule_5_title' => '5. The Bard\'s Burden',
			'doc_rule_5_desc' => 'You are solely responsible for your Thu\'um. We take no blame for your voice.',
			'doc_rule_6_title' => '6. The Cowl\'s Promise',
			'doc_rule_6_desc' => 'You are a shadow, unless you choose to drop the cowl and summon a Courier.',
			'doc_rule_7_title' => '7. Soul Severance',
			'doc_rule_7_desc' => 'You may sever your soul from the realm at will. This is irreversible.',
			'doc_rule_8_title' => '8. No Dark Brotherhood',
			'doc_rule_8_desc' => 'Torment is forbidden by the Jarl. Violators face the Headsman\'s Axe.',
			'doc_rule_9_title' => '9. Relics of the Realm',
			'doc_rule_9_desc' => 'All Runes and logic of this realm belong to the Architects of Amomimus.',
			'doc_rule_10_title' => '10. The Elder Council\'s Whim',
			'doc_rule_10_desc' => 'The Architects may rewrite these laws. By walking the roads, you obey the new edicts.',
			'unpin_memories' => 'Unbind Vahrukiv',
			'pin_memories' => 'Bind Vahrukiv',
			'report' => 'Call Guards',
			'show_less' => 'Read Less',
			'show_more' => 'Read More',
			'post_detail' => 'Tale Etched in Stone',
			'sticker_shop' => 'Belethor\'s Wares',
			'view' => 'Inspect',
			'buy' => 'Barter Faraan',
			'unlock_stickers' => 'Break the seals on new Runes here',
			'includes_exclusive_items' => 'Holds {count} rare artifacts',
			'stickers_inside' => '{count} {tier} enchanted runes inside.',
			'premium' => 'Daedric Premium',
			'already_own_batch' => 'You already have this artifact.',
			'not_enough_coins' => 'You don\'t have enough Faraan.',
			'emojis' => 'War Paints',
			'my_stickers' => 'My Runes',
			'no_stickers_owned' => 'Your satchel holds no Runes.',
			'sticker' => 'Rune',
			'message_deleted' => 'Rot burned',
			'my_sticker_stash' => 'My Rune Satchel',
			'stash_empty' => 'Your satchel is empty.',
			'visit_sticker_shop' => 'Visit Belethor\'s Wares to acquire Rune packs!',
			'stickers' => 'Runes',
			'own_these_stickers' => 'These enchantments are yours.',
			'chosen_amomus_prefix' => 'Your Patron Divine: ',
			'character_not_chosen' => 'You have no Patron yet!',
			'press_back_again' => 'Press back again to exit Skyrim',
			'ex_blocked' => 'OUTLAW',
			'blocked_users' => 'DUNGEON PRISONERS',
			'previously_blocked' => 'FORMER INMATES OUTLAWS',
			'no_blocked_users' => 'The dungeons are empty.',
			'splash_shutting_down' => 'OBLIVION CALLS...',
			'splash_unplug' => 'SEVERING MAGICKA TETHERS',
			'splash_returning' => 'RETURNING TO MUNDUS',
			'splash_no_signal' => 'THE ELDER SCROLL IS BLIND',
			'splash_stand_by' => 'BY THE NINE, TARRY...',
			'splash_embrace' => 'EMBRACE THE THU\'UM',
			'smileys_emotion' => 'Visages & Humors',
			'people_body' => 'Mer & Flesh',
			'animals_nature' => 'Creatures of Nirn',
			'food_drink' => 'Sweetrolls & Ale',
			'no_previous_blocks' => 'No pardoned souls.',
			'unblock' => 'Grant Pardon',
			'block_again' => 'Throw in Dungeon',
			'error_loading_account_data' => 'Krosis, the Scroll is corrupted!',
			'security_auth' => 'Wards & Locks',
			'favorite_character' => 'Patron Deity Safe Word',
			'edit_max_1_day' => 'Alter once per day',
			'forget_passcode' => 'Forgot the Dragon Claw Code?',
			'reset_passcode_hint' => 'Invoke your Patron Deity to unlock the door.',
			'reset_passcode' => 'Restore Claw Code',
			'email_already_registered_title' => 'Ritual Failed',
			'email_already_registered_desc' => 'This soul is already bound. Doth thou wish to awaken it instead?',
			'go_to_login' => 'Awaken',
			_ => null,
		};
	}
}
