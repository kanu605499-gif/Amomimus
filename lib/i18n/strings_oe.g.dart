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
class TranslationsOe extends Translations with BaseTranslations<AppLocale, Translations> {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	TranslationsOe({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.oe,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ),
		  super(cardinalResolver: cardinalResolver, ordinalResolver: ordinalResolver) {
		super.$meta.setFlatMapFunction($meta.getTranslation); // copy base translations to super.$meta
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <oe>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	@override dynamic operator[](String key) => $meta.getTranslation(key) ?? super.$meta.getTranslation(key);

	late final TranslationsOe _root = this; // ignore: unused_field

	@override 
	TranslationsOe $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => TranslationsOe(meta: meta ?? this.$meta);

	// Translations
	@override String get app_doc => 'Scroll Documentation';
	@override String get contact_dev => 'Summon Developers';
	@override String get language => 'Tongue';
	@override String get report_bug => 'Condemn a Curse';
	@override String get exit => 'Depart Gathering';
	@override String get center => 'Amomimus Sanctum';
	@override String get support_queries => 'For Succor and Aid Queries';
	@override String get help_support => 'SUCCOR & AID';
	@override String get public_name => 'Open Title';
	@override String get privacy_settings => 'Secrecy & Rites';
	@override String get danger_zone => 'Peril Domain';
	@override String get delete_account_warning => 'Deleting thy ledger shalt for eternity cleanse all local gathering knowledge, resonation histories, and preserved rites. This deed cannot be unmade.';
	@override String get privacy => 'Secrecy';
	@override String get about => 'Tales';
	@override String get policy => 'Decree';
	@override String get options => 'Rites';
	@override String get how_it_works => 'How Amomimus Works';
	@override String get report_bug_glitch => 'Report a Curse / Blight';
	@override String get terms_of => 'Covenants of ';
	@override String get privacy_rules_agreement => 'Secrecy & Decrees Pact';
	@override String get privacy_rules_text => 'Last reforged: May 2026\n\n1. Hold it Ethereal\nThou\'re a ghost hither, friend. Nay true names, nay farspeaker ciphers, and verily nay spilling thy former lover\'s dwelling or gossip networks names. We desire this void unto be utterly sundered from thy true-realm theatrics.\n\nIf thou by chance falter and unveil thy true visage or betray another else, do not await a omen. We shalt purge that proclamation swifter than thou canst wink, and thy passage may fade withal with it. Hold it 100% unseen.\n\n2. Do not Be a Total Scoundrel\nRaving? Fair. Weeping? We have thou. Lamenting tales how greatly thy labor or existence pains is precisely wherefore we forged this scroll, so be at liberty unto release thine ire without restraint.\n\nBut casting pure foul words, aimed torment, or cruelty another who is already fallen? Nay, that is a swift carriage unto being exiled. There be a most distinct boundary betwixt lamenting thy sorrow and merely being a wretched goblin.\n\n3. Naught Knowledge Hoarding\nWe do not purchase, barter, or even heed tales thy private knowledge. That which occurs within Amomimus, remains within Amomimus. Thy fleeting sessions art warded by magic and shalt be wiped pure in due time from our archives.\n\n4. Nay Merchant Bellowing\nThis stage is wrought for mortal passions, not for hawking thy cursed gold, boasting thy bazaar, or bellowing merchant pacts. Merchant cries without leave shalt bear fruit within an swift exile of thy vessel.\n\n5. Years of maturity\nTravelers must needs be no less than EIGHTEEN winters unto partake within this sightless fellowship. The writings bestowed hither canst be ripe, burdensome, and unhewn. Shield thy own mind\'s fortress ere perusing others\' lamentations.\n\n6. Content Mastery Proclamation\nThou own the words thou scribe, but by nailing them hither, thou bestow unto Amomimus a shared privilege unto show them nameless within the scroll tapestry. We shalt ne\'er demand thy sagas as our guild treasures.\n\n7. Condemn and Judgment Realm\nEven specters hast borders. If thou discover a proclamation that breaks our fellowship sanctuary edicts, employ the condemn tool posthaste. Our golem realm and justiciars scrutinize alarms DAY AND NIGHT.\n\n8. Dark deeds Exile\nDoth not employ this scroll unto scheme, muster, or incite any shape of dark deeds, bloodshed, or true-realm ruin. We bend with aetherial sanctuary mandates and shalt seize iron deed against transgressions.\n\n9. Scroll Divinations\nWe but gather nameless arcane tomes (like unto tales of ruin, shape of thy vessel, and realm tongue) unto make certain the scroll flows like silk upon thy farspeaker. Not one of these tomes canst be hunted unto thy true visage.\n\n10. Shiftings unto the Covenants\nAmomimus holds the privilege unto renew these decrees whenever it pleases unto mold unto fresh decrees or marvels. Continued employ of the scroll after reforgings signifies thou consent unto tread the newest ethereal rituals.';
	@override String get system_language => 'Amomimus Realm Tongue:';
	@override String get dob => 'Day of Thy Naming:';
	@override String get dob_required => '* Required â€” thou must select thy date of birth';
	@override String get agreement_verified => 'Pact verified';
	@override String get ready_to_verify => 'Ready unto verified our covenants?';
	@override String get age_warning => 'Thou must needs be no less than EIGHTEEN winters unto employ Amomimus.';
	@override String get accept_continue => 'Accept & Continue';
	@override String get select_birthday_first => 'Select thy birthday first';
	@override String get accept_terms_first => 'Accept the covenants first';
	@override String get mobile_app => 'Amomimus Portable Scroll';
	@override String get app_desc => 'A secure sanctuary and a tavern of nameless venting designed for aetherial catharsis.';
	@override String get share_to_chat => 'Chat This Soul';
	@override String get create_your => 'Forge Thy ';
	@override String get anonymous_username_label => 'NAMELESS ALIAS';
	@override String get leave_blank_random => 'Leave blank for a random title';
	@override String get enter_username_hint => 'Enter thy alias';
	@override String get id_generator_title => 'AMOMIMUS ID GENERATOR';
	@override String get random_generate_id => 'Random Generate ID:';
	@override String get choose_avatar_title => 'CHOOSE THY CHAMPION';
	@override String get incomplete_selection => 'Incomplete Selection';
	@override String get proceed => 'Venture Forth';
	@override String get choose_avatar_first => 'Prithee choose thy Amomus Avatar first!';
	@override String get incomplete_selection_desc_1 => 'Thou haven\'t ';
	@override String get incomplete_selection_desc_2 => '.\n\nThou won\'t be restricted, but thou shalt not hast thy custom title displayed unto thou. The realm shalt auto-generate a random one instead. Doth thou desire unto proceed?';
	@override String get you_found_easter_egg => 'Thou found the easter egg';
	@override String get developer => 'Architect:';
	@override String get skip => 'Pass';
	@override String get welcome_to => 'Hail and well met to ';
	@override String get safe_space_desc => 'A safe void unto share thy thoughts, ask questions, and connect with others.';
	@override String get identity_hidden_desc_1 => 'Thy true visage is hidden beneath an ';
	@override String get identity_hidden_desc_2 => ' title.';
	@override String get identity_protected_desc => 'We make certain thy visage is protected.\nParley freely without worrying tales who is upon the other side.';
	@override String get intro_indicators => 'Introducing Amomimus Indicators:';
	@override String get neutral => 'Neutral';
	@override String get users_participate_normally => ' travelers who partake normally.';
	@override String get amoral => 'Amoral';
	@override String get users_nonchalant => ' or nonchalant travelers unto watch out for.';
	@override String get toxic => 'Toxic';
	@override String get users_flagged => ' travelers flagged by the fellowship.';
	@override String get safe_and => 'Safe & ';
	@override String get respectful => 'Respectful';
	@override String get value_privacy_desc => 'We value secrecy and kindness. Prithee tread our fellowship decrees while thou explore.';
	@override String get app_version => 'Scroll Epoch:';
	@override String get create_post => 'Nail a Proclamation';
	@override String get whats_on_your_mind => 'What troubles thy mind, traveler?';
	@override String get send_post => 'Send Proclamation';
	@override String get notifications => 'Omens';
	@override String get no_notifications => 'Nay omens yet';
	@override String get no_feeds => 'Nay feeds available.';
	@override String get comments => 'Comments';
	@override String get no_comments => 'Nay comments yet. Be the first unto whisper!';
	@override String get add_comment => 'Add a whisper...';
	@override String get replying_to => 'Replying unto';
	@override String get chat_this_amomim => 'Parley with this soul';
	@override String get delete_post => 'Banish this proclamation';
	@override String get hide_feed => 'Hide this town square';
	@override String get report_amomim => 'Condemn this Amomim';
	@override String get resonated => 'Thy shout resonated';
	@override String get resonates => 'Shouts';
	@override String get chat_req_pending => 'Parley Request Pending...';
	@override String get indicator_noise_limit => 'Thy Amomimus Indicator is NOISE. Parley requests art prohibited.';
	@override String get ghost_limit_reached => 'GHOST Indicator limit reached: 7 parley requests per day.';
	@override String get initiate_chat => 'Initiate Parley';
	@override String get confirm_chat => 'Art thou sure thou desire unto parley with the author of this proclamation?\n\nThey shalt see thou as ';
	@override String get cancel => 'Forsake';
	@override String get send_request => 'Send Request';
	@override String get chat_req_sent => 'Parley Request Sent!';
	@override String get feed_hidden => 'Town square hidden.';
	@override String get bio => 'Bio';
	@override String get no_bio_yet => 'Nay bio yet';
	@override String get write_bio => 'Scribe thy bio...';
	@override String get select_date => 'Select Date';
	@override String get ok => 'SO BE IT';
	@override String get error_format => 'Invalid format';
	@override String get error_invalid => 'Invalid date';
	@override String get notif_resonate => 'resonated with thy proclamation';
	@override String get notif_comment => 'commented upon thy proclamation';
	@override String get notif_reply => 'replied unto thy whisper';
	@override String get just_now => 'Merely now';
	@override String get bio_updated => 'Bio reforged!';
	@override String get coins_redemption => 'Coins Redemption';
	@override String get redeemed_100_coins => 'Redeemed 100 Coins!';
	@override String get vault_merit => 'Vault & Merit';
	@override String get my_coins => 'Mine Septims';
	@override String get owned => 'Owned';
	@override String get sticker_stash => 'Sticker Stash';
	@override String get amomimus_indicators => 'Amomimus Indicators:';
	@override String get recent_resonates => 'Recent Resonates';
	@override String get see_all => 'See All';
	@override String get no_recent_resonates => 'Nay recent resonates.';
	@override String get all_resonates => 'All Resonates';
	@override String get no_resonates_yet => 'Nay resonates yet';
	@override String get delete_post_title => 'Banish Proclamation';
	@override String get delete_post_confirm => 'Art thou sure thou desire unto banish this proclamation? This shalt remove it from the town square.';
	@override String get delete_account => 'Banish Ledger';
	@override String get delete => 'Banish';
	@override String get profile_locked => 'Portrait Locked';
	@override String get locked_desc => 'Thou need unto establish a parley connection with this traveler unto view their full portrait.';
	@override String get profile => 'Portrait';
	@override String get no_active_user => 'Nay active traveler.';
	@override String get incoming_requests => 'Incoming Requests';
	@override String get no_incoming_requests => 'Nay incoming requests';
	@override String get chat_req_accepted => 'Parley request accepted!';
	@override String get messages => 'Messages';
	@override String get amomus_list => 'Amomus List';
	@override String get switch_account => 'Switch Ledger';
	@override String get no_accounts_registered => 'Nay accounts registered yet.';
	@override String get chat_requests => 'Parley Requests';
	@override String get chat_request_title => 'Parley Request';
	@override String get chat_request_desc1 => 'Sending a parley request unto this amomimus shalt unveil thy registered alias "';
	@override String get chat_request_desc2 => '" instead of thy town square title "';
	@override String get chat_request_desc3 => '".\n\nThey shalt also be able unto see thy portrait if they accept.';
	@override String get delete_chat_title => 'Banish Parley';
	@override String get delete_chat_confirm_prefix => 'Art thou sure thou desire unto banish this parley with ';
	@override String get delete_chat_confirm_suffix => '?';
	@override String get chat_deleted_prefix => 'Parley with ';
	@override String get chat_deleted_suffix => ' deleted';
	@override String get memories => 'Elder Scrolls';
	@override String get no_memories_pinned => 'Nay memories pinned yet.';
	@override String get delete_chat_room_confirm => 'Art thou sure thou desire unto banish this parley?';
	@override String get pin_limit_error => 'Thou canst but pin up unto 9 memories. Unpin one first!';
	@override String get write_message => 'Scribe message...';
	@override String get reply => 'Retort';
	@override String get doc_title => 'Scrolls of the Elder';
	@override String get doc_category_legal => 'Legal & Secrecy Decree';
	@override String get doc_rule_1_title => '1. Knowledge Collection';
	@override String get doc_rule_1_desc => 'We gather minimal knowledge necessary for core marvels. Thy nameless identifier is not linked unto thy private visage.';
	@override String get doc_rule_2_title => '2. End-unto-End Encryption';
	@override String get doc_rule_2_desc => 'All parley messages art end-unto-end warded by magic. We cannot read thy private messages.';
	@override String get doc_rule_3_title => '3. Gathering Knowledge';
	@override String get doc_rule_3_desc => 'Local gathering knowledge is stored securely upon thy device. Clearing thy scroll knowledge shalt for eternity erase thy local chronicles.';
	@override String get doc_rule_4_title => '4. Third-Party Services';
	@override String get doc_rule_4_desc => 'We doth not barter or share thy knowledge with third parties. Any external integrations art strictly for operational purposes.';
	@override String get doc_rule_5_title => '5. Traveler Content Liability';
	@override String get doc_rule_5_desc => 'Thou art solely responsible for the content thou proclamation. Amomimus is not liable for traveler-generated content.';
	@override String get doc_rule_6_title => '6. Anonymity Guarantee';
	@override String get doc_rule_6_desc => 'Thy open interactions remain nameless unless thou explicitly choose unto unveil thy visage via a parley request.';
	@override String get doc_rule_7_title => '7. Ledger Deletion';
	@override String get doc_rule_7_desc => 'Thou hast the privilege unto banish thy ledger at any time. This deed is irreversible and wipes all associated records.';
	@override String get doc_rule_8_title => '8. Torment & Abuse';
	@override String get doc_rule_8_desc => 'We maintain a iron naught-tolerance decree against torment. Violators shalt be for eternity banned.';
	@override String get doc_rule_9_title => '9. Intellectual Property';
	@override String get doc_rule_9_desc => 'All original assets, including stickers and UI elements, art the intellectual property of Amomimus.';
	@override String get doc_rule_10_title => '10. Decree Reforgings';
	@override String get doc_rule_10_desc => 'We reserve the privilege unto renew these covenants. Continued employ of the scroll constitutes acceptance of the fresh covenants.';
	@override String get unpin_memories => 'Tear from Elder Scrolls';
	@override String get pin_memories => 'Bind to Elder Scrolls';
	@override String get report => 'Condemn';
	@override String get show_less => 'Show less';
	@override String get show_more => 'Show more';
	@override String get post_detail => 'Proclamation Detail';
	@override String get sticker_shop => 'Khajiit\'s Wares';
	@override String get view => 'View';
	@override String get buy => 'Barter';
	@override String get unlock_stickers => 'Unlock thy stickers hither';
	@override String get includes_exclusive_items => 'Includes {count} exclusive items';
	@override String get stickers_inside => '{count} {tier} stickers inside.';
	@override String get premium => 'premium';
	@override String get already_own_batch => 'Thou already possesseth this batch.';
	@override String get not_enough_coins => 'Thou hast not enough Septims.';
	@override String get emojis => 'Emojis';
	@override String get my_stickers => 'Mine Stickers';
	@override String get no_stickers_owned => 'Nay stickers owned yet.';
	@override String get sticker => 'Sticker';
	@override String get message_deleted => 'Message deleted';
	@override String get my_sticker_stash => 'Mine Sticker Stash';
	@override String get stash_empty => 'Thy stash is empty.';
	@override String get visit_sticker_shop => 'Visit the Sticker Shop unto grab some packs!';
	@override String get stickers => 'Stickers';
	@override String get own_these_stickers => 'Thou own these stickers.';
	@override String get chosen_amomus_prefix => 'Thy chosen Amomus: ';
	@override String get character_not_chosen => 'Character not chosen yet!';
	@override String get press_back_again => 'Press back again unto depart';
	@override String get ex_blocked => 'FUGITIVE';
	@override String get blocked_users => 'BANISHED ONES';
	@override String get previously_blocked => 'FORMERLY BANISHED (FUGITIVES)';
	@override String get no_blocked_users => 'Thou hast banished no soul.';
	@override String get splash_shutting_down => 'THE REALM FADETH...';
	@override String get splash_unplug => 'FORSAKING THE CURSED APPARATUS';
	@override String get splash_returning => 'RETURNING UNTO WAKING LIFE';
	@override String get splash_no_signal => 'A GREAT SILENCE PREVAILS';
	@override String get splash_stand_by => 'TARRY AWHILE...';
	@override String get splash_embrace => 'EMBRACE THY CACOPHONY';
	@override String get smileys_emotion => 'Smirkings & Passions';
	@override String get people_body => 'Folke & Flesh';
	@override String get animals_nature => 'Beastes & Wyld';
	@override String get food_drink => 'Sustenance & Ale';
	@override String get no_previous_blocks => 'Nay prior banishments.';
	@override String get unblock => 'Forgive';
	@override String get block_again => 'Banish Anew';
	@override String get error_loading_account_data => 'Alas, thy scroll could not be read.';
	@override String get security_auth => 'Vault & Protection';
	@override String get favorite_character => 'Chosen Hero (Safe Word)';
	@override String get edit_max_1_day => 'Alter (Once a Moon)';
	@override String get forget_passcode => 'Lost the Code?';
	@override String get reset_passcode_hint => 'Speak thy hero to regain entry.';
	@override String get reset_passcode => 'Restore Code';
	@override String get email_already_registered_title => 'Registration Failed';
	@override String get email_already_registered_desc => 'This ethereal thread is already bound. Wouldst thou like unto log in instead?';
	@override String get go_to_login => 'Go to Login';
}

/// The flat map containing all translations for locale <oe>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on TranslationsOe {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'app_doc' => 'Scroll Documentation',
			'contact_dev' => 'Summon Developers',
			'language' => 'Tongue',
			'report_bug' => 'Condemn a Curse',
			'exit' => 'Depart Gathering',
			'center' => 'Amomimus Sanctum',
			'support_queries' => 'For Succor and Aid Queries',
			'help_support' => 'SUCCOR & AID',
			'public_name' => 'Open Title',
			'privacy_settings' => 'Secrecy & Rites',
			'danger_zone' => 'Peril Domain',
			'delete_account_warning' => 'Deleting thy ledger shalt for eternity cleanse all local gathering knowledge, resonation histories, and preserved rites. This deed cannot be unmade.',
			'privacy' => 'Secrecy',
			'about' => 'Tales',
			'policy' => 'Decree',
			'options' => 'Rites',
			'how_it_works' => 'How Amomimus Works',
			'report_bug_glitch' => 'Report a Curse / Blight',
			'terms_of' => 'Covenants of ',
			'privacy_rules_agreement' => 'Secrecy & Decrees Pact',
			'privacy_rules_text' => 'Last reforged: May 2026\n\n1. Hold it Ethereal\nThou\'re a ghost hither, friend. Nay true names, nay farspeaker ciphers, and verily nay spilling thy former lover\'s dwelling or gossip networks names. We desire this void unto be utterly sundered from thy true-realm theatrics.\n\nIf thou by chance falter and unveil thy true visage or betray another else, do not await a omen. We shalt purge that proclamation swifter than thou canst wink, and thy passage may fade withal with it. Hold it 100% unseen.\n\n2. Do not Be a Total Scoundrel\nRaving? Fair. Weeping? We have thou. Lamenting tales how greatly thy labor or existence pains is precisely wherefore we forged this scroll, so be at liberty unto release thine ire without restraint.\n\nBut casting pure foul words, aimed torment, or cruelty another who is already fallen? Nay, that is a swift carriage unto being exiled. There be a most distinct boundary betwixt lamenting thy sorrow and merely being a wretched goblin.\n\n3. Naught Knowledge Hoarding\nWe do not purchase, barter, or even heed tales thy private knowledge. That which occurs within Amomimus, remains within Amomimus. Thy fleeting sessions art warded by magic and shalt be wiped pure in due time from our archives.\n\n4. Nay Merchant Bellowing\nThis stage is wrought for mortal passions, not for hawking thy cursed gold, boasting thy bazaar, or bellowing merchant pacts. Merchant cries without leave shalt bear fruit within an swift exile of thy vessel.\n\n5. Years of maturity\nTravelers must needs be no less than EIGHTEEN winters unto partake within this sightless fellowship. The writings bestowed hither canst be ripe, burdensome, and unhewn. Shield thy own mind\'s fortress ere perusing others\' lamentations.\n\n6. Content Mastery Proclamation\nThou own the words thou scribe, but by nailing them hither, thou bestow unto Amomimus a shared privilege unto show them nameless within the scroll tapestry. We shalt ne\'er demand thy sagas as our guild treasures.\n\n7. Condemn and Judgment Realm\nEven specters hast borders. If thou discover a proclamation that breaks our fellowship sanctuary edicts, employ the condemn tool posthaste. Our golem realm and justiciars scrutinize alarms DAY AND NIGHT.\n\n8. Dark deeds Exile\nDoth not employ this scroll unto scheme, muster, or incite any shape of dark deeds, bloodshed, or true-realm ruin. We bend with aetherial sanctuary mandates and shalt seize iron deed against transgressions.\n\n9. Scroll Divinations\nWe but gather nameless arcane tomes (like unto tales of ruin, shape of thy vessel, and realm tongue) unto make certain the scroll flows like silk upon thy farspeaker. Not one of these tomes canst be hunted unto thy true visage.\n\n10. Shiftings unto the Covenants\nAmomimus holds the privilege unto renew these decrees whenever it pleases unto mold unto fresh decrees or marvels. Continued employ of the scroll after reforgings signifies thou consent unto tread the newest ethereal rituals.',
			'system_language' => 'Amomimus Realm Tongue:',
			'dob' => 'Day of Thy Naming:',
			'dob_required' => '* Required â€” thou must select thy date of birth',
			'agreement_verified' => 'Pact verified',
			'ready_to_verify' => 'Ready unto verified our covenants?',
			'age_warning' => 'Thou must needs be no less than EIGHTEEN winters unto employ Amomimus.',
			'accept_continue' => 'Accept & Continue',
			'select_birthday_first' => 'Select thy birthday first',
			'accept_terms_first' => 'Accept the covenants first',
			'mobile_app' => 'Amomimus Portable Scroll',
			'app_desc' => 'A secure sanctuary and a tavern of nameless venting designed for aetherial catharsis.',
			'share_to_chat' => 'Chat This Soul',
			'create_your' => 'Forge Thy ',
			'anonymous_username_label' => 'NAMELESS ALIAS',
			'leave_blank_random' => 'Leave blank for a random title',
			'enter_username_hint' => 'Enter thy alias',
			'id_generator_title' => 'AMOMIMUS ID GENERATOR',
			'random_generate_id' => 'Random Generate ID:',
			'choose_avatar_title' => 'CHOOSE THY CHAMPION',
			'incomplete_selection' => 'Incomplete Selection',
			'proceed' => 'Venture Forth',
			'choose_avatar_first' => 'Prithee choose thy Amomus Avatar first!',
			'incomplete_selection_desc_1' => 'Thou haven\'t ',
			'incomplete_selection_desc_2' => '.\n\nThou won\'t be restricted, but thou shalt not hast thy custom title displayed unto thou. The realm shalt auto-generate a random one instead. Doth thou desire unto proceed?',
			'you_found_easter_egg' => 'Thou found the easter egg',
			'developer' => 'Architect:',
			'skip' => 'Pass',
			'welcome_to' => 'Hail and well met to ',
			'safe_space_desc' => 'A safe void unto share thy thoughts, ask questions, and connect with others.',
			'identity_hidden_desc_1' => 'Thy true visage is hidden beneath an ',
			'identity_hidden_desc_2' => ' title.',
			'identity_protected_desc' => 'We make certain thy visage is protected.\nParley freely without worrying tales who is upon the other side.',
			'intro_indicators' => 'Introducing Amomimus Indicators:',
			'neutral' => 'Neutral',
			'users_participate_normally' => ' travelers who partake normally.',
			'amoral' => 'Amoral',
			'users_nonchalant' => ' or nonchalant travelers unto watch out for.',
			'toxic' => 'Toxic',
			'users_flagged' => ' travelers flagged by the fellowship.',
			'safe_and' => 'Safe & ',
			'respectful' => 'Respectful',
			'value_privacy_desc' => 'We value secrecy and kindness. Prithee tread our fellowship decrees while thou explore.',
			'app_version' => 'Scroll Epoch:',
			'create_post' => 'Nail a Proclamation',
			'whats_on_your_mind' => 'What troubles thy mind, traveler?',
			'send_post' => 'Send Proclamation',
			'notifications' => 'Omens',
			'no_notifications' => 'Nay omens yet',
			'no_feeds' => 'Nay feeds available.',
			'comments' => 'Comments',
			'no_comments' => 'Nay comments yet. Be the first unto whisper!',
			'add_comment' => 'Add a whisper...',
			'replying_to' => 'Replying unto',
			'chat_this_amomim' => 'Parley with this soul',
			'delete_post' => 'Banish this proclamation',
			'hide_feed' => 'Hide this town square',
			'report_amomim' => 'Condemn this Amomim',
			'resonated' => 'Thy shout resonated',
			'resonates' => 'Shouts',
			'chat_req_pending' => 'Parley Request Pending...',
			'indicator_noise_limit' => 'Thy Amomimus Indicator is NOISE. Parley requests art prohibited.',
			'ghost_limit_reached' => 'GHOST Indicator limit reached: 7 parley requests per day.',
			'initiate_chat' => 'Initiate Parley',
			'confirm_chat' => 'Art thou sure thou desire unto parley with the author of this proclamation?\n\nThey shalt see thou as ',
			'cancel' => 'Forsake',
			'send_request' => 'Send Request',
			'chat_req_sent' => 'Parley Request Sent!',
			'feed_hidden' => 'Town square hidden.',
			'bio' => 'Bio',
			'no_bio_yet' => 'Nay bio yet',
			'write_bio' => 'Scribe thy bio...',
			'select_date' => 'Select Date',
			'ok' => 'SO BE IT',
			'error_format' => 'Invalid format',
			'error_invalid' => 'Invalid date',
			'notif_resonate' => 'resonated with thy proclamation',
			'notif_comment' => 'commented upon thy proclamation',
			'notif_reply' => 'replied unto thy whisper',
			'just_now' => 'Merely now',
			'bio_updated' => 'Bio reforged!',
			'coins_redemption' => 'Coins Redemption',
			'redeemed_100_coins' => 'Redeemed 100 Coins!',
			'vault_merit' => 'Vault & Merit',
			'my_coins' => 'Mine Septims',
			'owned' => 'Owned',
			'sticker_stash' => 'Sticker Stash',
			'amomimus_indicators' => 'Amomimus Indicators:',
			'recent_resonates' => 'Recent Resonates',
			'see_all' => 'See All',
			'no_recent_resonates' => 'Nay recent resonates.',
			'all_resonates' => 'All Resonates',
			'no_resonates_yet' => 'Nay resonates yet',
			'delete_post_title' => 'Banish Proclamation',
			'delete_post_confirm' => 'Art thou sure thou desire unto banish this proclamation? This shalt remove it from the town square.',
			'delete_account' => 'Banish Ledger',
			'delete' => 'Banish',
			'profile_locked' => 'Portrait Locked',
			'locked_desc' => 'Thou need unto establish a parley connection with this traveler unto view their full portrait.',
			'profile' => 'Portrait',
			'no_active_user' => 'Nay active traveler.',
			'incoming_requests' => 'Incoming Requests',
			'no_incoming_requests' => 'Nay incoming requests',
			'chat_req_accepted' => 'Parley request accepted!',
			'messages' => 'Messages',
			'amomus_list' => 'Amomus List',
			'switch_account' => 'Switch Ledger',
			'no_accounts_registered' => 'Nay accounts registered yet.',
			'chat_requests' => 'Parley Requests',
			'chat_request_title' => 'Parley Request',
			'chat_request_desc1' => 'Sending a parley request unto this amomimus shalt unveil thy registered alias "',
			'chat_request_desc2' => '" instead of thy town square title "',
			'chat_request_desc3' => '".\n\nThey shalt also be able unto see thy portrait if they accept.',
			'delete_chat_title' => 'Banish Parley',
			'delete_chat_confirm_prefix' => 'Art thou sure thou desire unto banish this parley with ',
			'delete_chat_confirm_suffix' => '?',
			'chat_deleted_prefix' => 'Parley with ',
			'chat_deleted_suffix' => ' deleted',
			'memories' => 'Elder Scrolls',
			'no_memories_pinned' => 'Nay memories pinned yet.',
			'delete_chat_room_confirm' => 'Art thou sure thou desire unto banish this parley?',
			'pin_limit_error' => 'Thou canst but pin up unto 9 memories. Unpin one first!',
			'write_message' => 'Scribe message...',
			'reply' => 'Retort',
			'doc_title' => 'Scrolls of the Elder',
			'doc_category_legal' => 'Legal & Secrecy Decree',
			'doc_rule_1_title' => '1. Knowledge Collection',
			'doc_rule_1_desc' => 'We gather minimal knowledge necessary for core marvels. Thy nameless identifier is not linked unto thy private visage.',
			'doc_rule_2_title' => '2. End-unto-End Encryption',
			'doc_rule_2_desc' => 'All parley messages art end-unto-end warded by magic. We cannot read thy private messages.',
			'doc_rule_3_title' => '3. Gathering Knowledge',
			'doc_rule_3_desc' => 'Local gathering knowledge is stored securely upon thy device. Clearing thy scroll knowledge shalt for eternity erase thy local chronicles.',
			'doc_rule_4_title' => '4. Third-Party Services',
			'doc_rule_4_desc' => 'We doth not barter or share thy knowledge with third parties. Any external integrations art strictly for operational purposes.',
			'doc_rule_5_title' => '5. Traveler Content Liability',
			'doc_rule_5_desc' => 'Thou art solely responsible for the content thou proclamation. Amomimus is not liable for traveler-generated content.',
			'doc_rule_6_title' => '6. Anonymity Guarantee',
			'doc_rule_6_desc' => 'Thy open interactions remain nameless unless thou explicitly choose unto unveil thy visage via a parley request.',
			'doc_rule_7_title' => '7. Ledger Deletion',
			'doc_rule_7_desc' => 'Thou hast the privilege unto banish thy ledger at any time. This deed is irreversible and wipes all associated records.',
			'doc_rule_8_title' => '8. Torment & Abuse',
			'doc_rule_8_desc' => 'We maintain a iron naught-tolerance decree against torment. Violators shalt be for eternity banned.',
			'doc_rule_9_title' => '9. Intellectual Property',
			'doc_rule_9_desc' => 'All original assets, including stickers and UI elements, art the intellectual property of Amomimus.',
			'doc_rule_10_title' => '10. Decree Reforgings',
			'doc_rule_10_desc' => 'We reserve the privilege unto renew these covenants. Continued employ of the scroll constitutes acceptance of the fresh covenants.',
			'unpin_memories' => 'Tear from Elder Scrolls',
			'pin_memories' => 'Bind to Elder Scrolls',
			'report' => 'Condemn',
			'show_less' => 'Show less',
			'show_more' => 'Show more',
			'post_detail' => 'Proclamation Detail',
			'sticker_shop' => 'Khajiit\'s Wares',
			'view' => 'View',
			'buy' => 'Barter',
			'unlock_stickers' => 'Unlock thy stickers hither',
			'includes_exclusive_items' => 'Includes {count} exclusive items',
			'stickers_inside' => '{count} {tier} stickers inside.',
			'premium' => 'premium',
			'already_own_batch' => 'Thou already possesseth this batch.',
			'not_enough_coins' => 'Thou hast not enough Septims.',
			'emojis' => 'Emojis',
			'my_stickers' => 'Mine Stickers',
			'no_stickers_owned' => 'Nay stickers owned yet.',
			'sticker' => 'Sticker',
			'message_deleted' => 'Message deleted',
			'my_sticker_stash' => 'Mine Sticker Stash',
			'stash_empty' => 'Thy stash is empty.',
			'visit_sticker_shop' => 'Visit the Sticker Shop unto grab some packs!',
			'stickers' => 'Stickers',
			'own_these_stickers' => 'Thou own these stickers.',
			'chosen_amomus_prefix' => 'Thy chosen Amomus: ',
			'character_not_chosen' => 'Character not chosen yet!',
			'press_back_again' => 'Press back again unto depart',
			'ex_blocked' => 'FUGITIVE',
			'blocked_users' => 'BANISHED ONES',
			'previously_blocked' => 'FORMERLY BANISHED (FUGITIVES)',
			'no_blocked_users' => 'Thou hast banished no soul.',
			'splash_shutting_down' => 'THE REALM FADETH...',
			'splash_unplug' => 'FORSAKING THE CURSED APPARATUS',
			'splash_returning' => 'RETURNING UNTO WAKING LIFE',
			'splash_no_signal' => 'A GREAT SILENCE PREVAILS',
			'splash_stand_by' => 'TARRY AWHILE...',
			'splash_embrace' => 'EMBRACE THY CACOPHONY',
			'smileys_emotion' => 'Smirkings & Passions',
			'people_body' => 'Folke & Flesh',
			'animals_nature' => 'Beastes & Wyld',
			'food_drink' => 'Sustenance & Ale',
			'no_previous_blocks' => 'Nay prior banishments.',
			'unblock' => 'Forgive',
			'block_again' => 'Banish Anew',
			'error_loading_account_data' => 'Alas, thy scroll could not be read.',
			'security_auth' => 'Vault & Protection',
			'favorite_character' => 'Chosen Hero (Safe Word)',
			'edit_max_1_day' => 'Alter (Once a Moon)',
			'forget_passcode' => 'Lost the Code?',
			'reset_passcode_hint' => 'Speak thy hero to regain entry.',
			'reset_passcode' => 'Restore Code',
			'email_already_registered_title' => 'Registration Failed',
			'email_already_registered_desc' => 'This ethereal thread is already bound. Wouldst thou like unto log in instead?',
			'go_to_login' => 'Go to Login',
			_ => null,
		};
	}
}
