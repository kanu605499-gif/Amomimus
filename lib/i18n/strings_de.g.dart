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
class TranslationsDe extends Translations with BaseTranslations<AppLocale, Translations> {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	TranslationsDe({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.de,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ),
		  super(cardinalResolver: cardinalResolver, ordinalResolver: ordinalResolver) {
		super.$meta.setFlatMapFunction($meta.getTranslation); // copy base translations to super.$meta
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <de>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	@override dynamic operator[](String key) => $meta.getTranslation(key) ?? super.$meta.getTranslation(key);

	late final TranslationsDe _root = this; // ignore: unused_field

	@override 
	TranslationsDe $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => TranslationsDe(meta: meta ?? this.$meta);

	// Translations
	@override String get app_doc => 'App-Dokumentation';
	@override String get contact_dev => 'Entwickler kontaktieren';
	@override String get language => 'Sprache';
	@override String get report_bug => 'Bug melden';
	@override String get exit => 'Sitzung beenden';
	@override String get center => 'Amomimus-Center';
	@override String get support_queries => 'Für Hilfe- und Supportanfragen';
	@override String get help_support => 'HILFE & SUPPORT';
	@override String get public_name => 'Öffentlicher Name';
	@override String get privacy_settings => 'Datenschutz & Einstellungen';
	@override String get danger_zone => 'Gefahrenzone';
	@override String get delete_account_warning => 'Das Löschen deines Accounts löscht dauerhaft alle lokalen Sitzungsdaten, Resonanzhistorien und gespeicherten Einstellungen. Diese Aktion kann nicht rückgängig gemacht werden.';
	@override String get privacy => 'Datenschutz';
	@override String get about => 'Über uns';
	@override String get policy => 'Richtlinien';
	@override String get options => 'Optionen';
	@override String get how_it_works => 'Wie Amomimus funktioniert';
	@override String get report_bug_glitch => 'Einen Bug / Fehler melden';
	@override String get terms_of => 'Nutzungsbedingungen von ';
	@override String get privacy_rules_agreement => 'Datenschutz & Regelvereinbarung';
	@override String get privacy_rules_text => 'Zuletzt aktualisiert: Mai 2026\n\n1. Bleib ein Geist\nDu bist hier ein Geist. Keine echten Namen, keine Telefonnummern und schon gar kein Leaken der Adresse deines Ex oder Social-Media-Accounts. Wir wollen, dass dieser Raum komplett losgelöst von deinem echten Drama ist.\n\nWenn du versehentlich deine wahre Identität preisgibst oder jemanden doxt, erwarte keine Warnung. Wir löschen diesen Beitrag schneller als du blinzeln kannst, und dein Zugang verschwindet möglicherweise gleich mit. Bleib zu 100 % inkognito.\n\n2. Sei kein Arschloch\nSich auskotzen? Cool. Weinen? Wir verstehen dich. Deinen Frust über deinen Job oder dein Leben abzulassen, ist genau der Grund, warum wir diese App entwickelt haben, also lass ruhig Dampf ab.\n\nAber direkte Hassrede, gezieltes Mobbing oder jemanden schikanieren, der ohnehin schon am Boden ist? Nein, das ist der schnellste Weg, rauszufliegen. Es gibt eine klare Grenze zwischen Frust ablassen und einem erbärmlichen Troll zu sein.\n\n3. Keine Vorratsspeicherung von Daten\nWir kaufen, verkaufen oder interessieren uns nicht einmal für deine persönlichen Daten. Was bei Amomimus passiert, bleibt bei Amomimus. Deine temporären Sitzungen sind verschlüsselt und werden regelmäßig komplett von unseren Servern gelöscht.\n\n4. Kein kommerzielles Spamming\nDiese Plattform wurde für menschliche Emotionen geschaffen, nicht um deine Krypto-Coins zu verkaufen, deinen Online-Shop zu bewerben oder Affiliate-Links zu spammen. Kommerzielle Werbung ohne Erlaubnis führt zu einem sofortigen Hardware-Bann.\n\n5. Altersbeschränkung\nNutzer müssen mindestens 18 Jahre alt sein, um an dieser blinden Community teilzunehmen. Die hier geteilten Inhalte können erwachsen, schwer und ungeschönt sein. Schütze deine eigene psychische Gesundheit, bevor du die Rants anderer liest.\n\n6. Haftungsausschluss zum Inhalt\nDir gehören die Worte, die du schreibst, aber durch das Posten hier gewährst du Amomimus ein nicht-exklusives Recht, sie anonym innerhalb der App-Oberfläche anzuzeigen. Wir werden deine Geschichten niemals als unser Firmeneigentum beanspruchen.\n\n7. Melde- und Moderationssystem\nSelbst Geister haben Grenzen. Wenn du einen Beitrag findest, der gegen unsere Sicherheitsrichtlinien verstößt, nutze sofort die Meldefunktion. Unser automatisiertes System und Moderatoren überprüfen Meldungen rund um die Uhr.\n\n8. Verbot illegaler Aktivitäten\nNutze diese App nicht, um jegliche Form illegaler Aktivitäten, physischer Gewalt oder realer Gefahren zu planen, zu koordinieren oder zu fördern. Wir halten uns an digitale Sicherheitsvorschriften und werden bei Verstößen streng durchgreifen.\n\n9. App-Analyse\nWir sammeln nur anonyme technische Protokolle (wie Absturzberichte, Gerätemodelle und Systemsprachen), um sicherzustellen, dass die App reibungslos auf deinem Handy läuft. Keines dieser Protokolle kann zu deiner wahren Identität zurückverfolgt werden.\n\n10. Änderungen der Bedingungen\nAmomimus behält sich das Recht vor, diese Regeln jederzeit zu aktualisieren, um sich an neue Gesetze oder Funktionen anzupassen. Die weitere Nutzung der App nach Aktualisierungen bedeutet, dass du den neuesten Geist-Protokollen zustimmst.';
	@override String get system_language => 'Amomimus Systemsprache:';
	@override String get dob => 'Geburtsdatum:';
	@override String get dob_required => '* Erforderlich – Sie müssen Ihr Geburtsdatum auswählen';
	@override String get agreement_verified => 'Vereinbarung überprüft';
	@override String get ready_to_verify => 'Sind Sie bereit, unsere Bedingungen zu überprüfen?';
	@override String get age_warning => 'Um Amomimus verwenden zu können, müssen Sie mindestens 18 Jahre alt sein.';
	@override String get accept_continue => 'Akzeptieren und fortfahren';
	@override String get select_birthday_first => 'Wählen Sie zunächst Ihren Geburtstag aus';
	@override String get accept_terms_first => 'Akzeptieren Sie zunächst die Bedingungen';
	@override String get mobile_app => 'Amomimus Mobile App';
	@override String get app_desc => 'Ein sicherer Raum für anonymes Auskotzen, konzipiert für digitale Katharsis.';
	@override String get create_your => 'Erstellen Sie Ihr';
	@override String get anonymous_username_label => 'ANONYMER BENUTZERNAME';
	@override String get leave_blank_random => 'Für einen zufälligen Namen leer lassen';
	@override String get enter_username_hint => 'Geben Sie Ihren Benutzernamen ein';
	@override String get id_generator_title => 'AMOMIMUS ID-GENERATOR';
	@override String get random_generate_id => 'Zufällig generierte ID:';
	@override String get choose_avatar_title => 'WÄHLEN SIE IHREN AMOMUS-AVATAR';
	@override String get incomplete_selection => 'Unvollständige Auswahl';
	@override String get proceed => 'Fortfahren';
	@override String get choose_avatar_first => 'Bitte wählen Sie zuerst Ihren Amomus-Avatar!';
	@override String get incomplete_selection_desc_1 => 'Das hast du nicht';
	@override String get incomplete_selection_desc_2 => '.\n\nSie werden nicht eingeschränkt, Ihr individueller Name wird Ihnen jedoch nicht angezeigt. Das System generiert stattdessen automatisch ein zufälliges Ergebnis. Möchten Sie fortfahren?';
	@override String get you_found_easter_egg => 'Du hast das Osterei gefunden';
	@override String get developer => 'Entwickler:';
	@override String get skip => 'Überspringen';
	@override String get welcome_to => 'Willkommen bei';
	@override String get safe_space_desc => 'Ein sicherer Ort, um Ihre Gedanken auszutauschen, Fragen zu stellen und mit anderen in Kontakt zu treten.';
	@override String get identity_hidden_desc_1 => 'Ihre wahre Identität ist unter einem verborgen';
	@override String get identity_hidden_desc_2 => 'Name.';
	@override String get identity_protected_desc => 'Wir sorgen dafür, dass Ihre Identität geschützt ist.\nChatten Sie frei, ohne sich Gedanken darüber machen zu müssen, wer auf der anderen Seite ist.';
	@override String get intro_indicators => 'Einführung in Amomimus-Indikatoren:';
	@override String get neutral => 'Neutral';
	@override String get users_participate_normally => 'Benutzer, die normal teilnehmen.';
	@override String get amoral => 'Amoralisch';
	@override String get users_nonchalant => 'oder lässige Benutzer, auf die man achten sollte.';
	@override String get toxic => 'Giftig';
	@override String get users_flagged => 'Von der Community markierte Benutzer.';
	@override String get safe_and => 'Sicher &';
	@override String get respectful => 'Respektvoll';
	@override String get value_privacy_desc => 'Wir legen Wert auf Privatsphäre und Freundlichkeit. Bitte befolgen Sie beim Erkunden unsere Community-Regeln.';
	@override String get app_version => 'App-Version:';
  @override String get share_to_chat => 'Im Chat teilen';
	@override String get create_post => 'Einen Post erstellen';
	@override String get whats_on_your_mind => 'Was geht dir durch den Kopf? (Anonym)';
	@override String get send_post => 'Posten';
	@override String get notifications => 'Benachrichtigungen';
	@override String get no_notifications => 'Noch keine Benachrichtigungen';
	@override String get no_feeds => 'Keine Feeds verfügbar.';
	@override String get comments => 'Kommentare';
	@override String get no_comments => 'Noch keine Kommentare. Sei der Erste!';
	@override String get add_comment => 'Kommentar hinzufügen...';
	@override String get replying_to => 'Antwort an';
	@override String get chat_this_amomim => 'Mit diesem Amomim chatten';
	@override String get delete_post => 'Diesen Post löschen';
	@override String get hide_feed => 'Diesen Feed verbergen';
	@override String get report_amomim => 'Diesen Amomim melden';
	@override String get resonated => 'Hat resoniert';
	@override String get resonates => 'Resoniert';
	@override String get chat_req_pending => 'Chat-Anfrage ausstehend...';
	@override String get indicator_noise_limit => 'Dein Amomimus-Indikator ist NOISE. Chat-Anfragen sind verboten.';
	@override String get ghost_limit_reached => 'GHOST-Indikator-Limit erreicht: 7 Chat-Anfragen pro Tag.';
	@override String get initiate_chat => 'Chat starten';
	@override String get confirm_chat => 'Möchtest du wirklich mit dem Autor dieses Posts chatten?\n\nSie werden dich sehen als ';
	@override String get cancel => 'Abbrechen';
	@override String get send_request => 'Anfrage senden';
	@override String get chat_req_sent => 'Chat-Anfrage gesendet!';
	@override String get feed_hidden => 'Feed verborgen.';
	@override String get bio => 'Bio';
	@override String get no_bio_yet => 'Noch keine Bio';
	@override String get write_bio => 'Schreibe deine Bio...';
	@override String get select_date => 'Datum auswählen';
	@override String get ok => 'OK';
	@override String get error_format => 'Ungültiges Format';
	@override String get error_invalid => 'Ungültiges Datum';
	@override String get notif_resonate => 'hat mit deinem Post resoniert';
	@override String get notif_comment => 'hat deinen Post kommentiert';
	@override String get notif_reply => 'hat auf deinen Kommentar geantwortet';
	@override String get just_now => 'Gerade eben';
	@override String get bio_updated => 'Bio aktualisiert!';
	@override String get coins_redemption => 'Münzen einlösen';
	@override String get redeemed_100_coins => '100 Münzen eingelöst!';
	@override String get vault_merit => 'Vault & Merit';
	@override String get my_coins => 'Meine Münzen';
	@override String get owned => 'Im Besitz';
	@override String get sticker_stash => 'Sticker-Vorrat';
	@override String get amomimus_indicators => 'Amomimus-Indikatoren:';
	@override String get recent_resonates => 'Kürzliche Resonanzen';
	@override String get see_all => 'Alle ansehen';
	@override String get no_recent_resonates => 'Keine kürzlichen Resonanzen.';
	@override String get all_resonates => 'Alle Resonanzen';
	@override String get no_resonates_yet => 'Noch keine Resonanzen';
	@override String get delete_post_title => 'Post löschen';
	@override String get delete_post_confirm => 'Möchtest du diesen Post wirklich löschen? Er wird endgültig aus dem Feed entfernt.';
	@override String get delete_account => 'Account löschen';
	@override String get delete => 'Löschen';
	@override String get profile_locked => 'Profil gesperrt';
	@override String get locked_desc => 'Du musst eine Chat-Verbindung mit diesem Nutzer aufbauen, um das vollständige Profil zu sehen.';
	@override String get profile => 'Profil';
	@override String get no_active_user => 'Kein aktiver Nutzer.';
	@override String get incoming_requests => 'Eingehende Anfragen';
	@override String get no_incoming_requests => 'Keine eingehenden Anfragen';
	@override String get chat_req_accepted => 'Chat-Anfrage akzeptiert!';
	@override String get messages => 'Nachrichten';
	@override String get amomus_list => 'Amomus-Liste';
	@override String get switch_account => 'Account wechseln';
	@override String get no_accounts_registered => 'Noch keine Accounts registriert.';
	@override String get chat_requests => 'Chat-Anfragen';
	@override String get chat_request_title => 'Chat-Anfrage';
	@override String get chat_request_desc1 => 'Das Senden einer Chat-Anfrage an diesen Amomimus enthüllt deinen registrierten Nutzernamen "';
	@override String get chat_request_desc2 => '" anstelle deines Feed-Namens "';
	@override String get chat_request_desc3 => '".\n\nWenn sie akzeptieren, können sie außerdem dein Profil sehen.';
	@override String get delete_chat_title => 'Chat löschen';
	@override String get delete_chat_confirm_prefix => 'Möchtest du den Chat mit ';
	@override String get delete_chat_confirm_suffix => ' wirklich löschen?';
	@override String get chat_deleted_prefix => 'Chat mit ';
	@override String get chat_deleted_suffix => ' wurde gelöscht';
	@override String get memories => 'Erinnerungen';
	@override String get no_memories_pinned => 'Noch keine Erinnerungen angepinnt.';
	@override String get delete_chat_room_confirm => 'Möchtest du diesen Chat wirklich löschen?';
	@override String get pin_limit_error => 'Du kannst nur bis zu 9 Erinnerungen anpinnen. Entferne zuerst eine!';
	@override String get write_message => 'Nachricht schreiben...';
	@override String get reply => 'Antworten';
	@override String get doc_title => 'App-Dokumentation';
	@override String get doc_category_legal => 'Rechtliches & Datenschutzrichtlinie';
	@override String get doc_rule_1_title => '1. Datenerhebung';
	@override String get doc_rule_1_desc => 'Wir sammeln nur die minimal erforderlichen Daten für unsere Hauptfunktionen. Dein anonymer Identifikator ist nicht mit deiner persönlichen Identität verknüpft.';
	@override String get doc_rule_2_title => '2. Ende-zu-Ende-Verschlüsselung';
	@override String get doc_rule_2_desc => 'Alle Chat-Nachrichten sind Ende-zu-Ende verschlüsselt. Wir können deine privaten Nachrichten nicht lesen.';
	@override String get doc_rule_3_title => '3. Sitzungsdaten';
	@override String get doc_rule_3_desc => 'Lokale Sitzungsdaten werden sicher auf deinem Gerät gespeichert. Das Löschen deiner App-Daten löscht deine lokale Historie dauerhaft.';
	@override String get doc_rule_4_title => '4. Dienste Dritter';
	@override String get doc_rule_4_desc => 'Wir verkaufen oder teilen deine Daten nicht mit Dritten. Externe Integrationen dienen ausschließlich betrieblichen Zwecken.';
	@override String get doc_rule_5_title => '5. Haftung für Nutzerinhalte';
	@override String get doc_rule_5_desc => 'Du bist allein verantwortlich für die Inhalte, die du postest. Amomimus haftet nicht für nutzergenerierte Inhalte.';
	@override String get doc_rule_6_title => '6. Anonymitätsgarantie';
	@override String get doc_rule_6_desc => 'Deine öffentlichen Interaktionen bleiben anonym, es sei denn, du entscheidest dich ausdrücklich dafür, deine Identität über eine Chat-Anfrage preiszugeben.';
	@override String get doc_rule_7_title => '7. Accountlöschung';
	@override String get doc_rule_7_desc => 'Du hast jederzeit das Recht, deinen Account zu löschen. Dieser Vorgang ist irreversibel und löscht alle zugehörigen Daten.';
	@override String get doc_rule_8_title => '8. Belästigung & Missbrauch';
	@override String get doc_rule_8_desc => 'Wir dulden absolut keine Belästigung. Zuwiderhandlungen werden dauerhaft gebannt.';
	@override String get doc_rule_9_title => '9. Geistiges Eigentum';
	@override String get doc_rule_9_desc => 'Alle Originalressourcen, einschließlich Sticker und UI-Elemente, sind geistiges Eigentum von Amomimus.';
	@override String get doc_rule_10_title => '10. Richtlinien-Updates';
	@override String get doc_rule_10_desc => 'Wir behalten uns das Recht vor, diese Bedingungen zu aktualisieren. Die weitere Nutzung der App gilt als Annahme der neuen Bedingungen.';
	@override String get unpin_memories => 'Von Erinnerungen lösen';
	@override String get pin_memories => 'Zu Erinnerungen pinnen';
	@override String get report => 'Melden';
	@override String get show_less => 'Weniger anzeigen';
	@override String get show_more => 'Mehr anzeigen';
	@override String get post_detail => 'Post-Details';
	@override String get sticker_shop => 'Sticker-Shop';
	@override String get view => 'Ansehen';
	@override String get buy => 'Kaufen';
	@override String get unlock_stickers => 'Schalte hier deine Sticker frei';
	@override String get includes_exclusive_items => 'Enthält {count} exklusive Items';
	@override String get stickers_inside => '{count} {tier} Sticker enthalten.';
	@override String get premium => 'Premium';
	@override String get already_own_batch => 'Du besitzt dieses Paket bereits.';
	@override String get not_enough_coins => 'Nicht genug Münzen.';
	@override String get emojis => 'Emojis';
	@override String get my_stickers => 'Meine Sticker';
	@override String get no_stickers_owned => 'Noch keine Sticker im Besitz.';
	@override String get sticker => 'Sticker';
	@override String get message_deleted => 'Nachricht gelöscht';
	@override String get my_sticker_stash => 'Mein Sticker-Vorrat';
	@override String get stash_empty => 'Dein Vorrat ist leer.';
	@override String get visit_sticker_shop => 'Besuche den Shop, um dir ein paar Packs zu schnappen!';
	@override String get stickers => 'Sticker';
	@override String get own_these_stickers => 'Dir gehören diese Sticker.';
	@override String get chosen_amomus_prefix => 'Dein gewählter Amomus: ';
	@override String get character_not_chosen => 'Charakter noch nicht ausgewählt!';
	@override String get press_back_again => 'Drücke nochmal zurück, um zu beenden';
	@override String get ex_blocked => 'EHEMALS BLOCKIERT';
	@override String get blocked_users => 'Blockierte Benutzer';
	@override String get previously_blocked => 'Zuvor blockierte Benutzer';
	@override String get no_blocked_users => 'Du hast niemanden blockiert.';
	@override String get splash_shutting_down => 'HERUNTERFAHREN...';
	@override String get splash_unplug => 'ZIEHEN SIE DIE DYSTOPIE AUS';
	@override String get splash_returning => 'ZURÜCK ZUR REALITÄT';
	@override String get splash_no_signal => 'KEIN SIGNAL';
	@override String get splash_stand_by => 'STEHEN ZU...';
	@override String get splash_embrace => 'UMARME DEN LÄRM';
	@override String get smileys_emotion => 'Smileys & Emotionen';
	@override String get people_body => 'Menschen & Körper';
	@override String get animals_nature => 'Tiere & Natur';
	@override String get food_drink => 'Essen & Trinken';
	@override String get no_previous_blocks => 'Keine vorherigen Blockierungen.';
	@override String get unblock => 'Entblocken';
	@override String get block_again => 'Wieder blockieren';
	@override String get error_loading_account_data => 'Fehler beim Laden der Account-Daten.';
	@override String get security_auth => 'Sicherheit & Authentifizierung';
	@override String get favorite_character => 'Lieblingscharakter (2FA/Wiederherstellung)';
	@override String get edit_max_1_day => 'Bearbeiten (Max 1/Tag)';
	@override String get forget_passcode => 'Passcode vergessen';
	@override String get reset_passcode_hint => 'Benutze deinen Lieblingscharakter, um den Passcode zurückzusetzen.';
	@override String get reset_passcode => 'Passcode zurücksetzen';
	@override String get share => 'Teilen';
	@override String get continue_btn => 'Weiter';
	@override String get validation_form => 'Validierungsformular';
}

/// The flat map containing all translations for locale <de>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on TranslationsDe {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'app_doc' => 'App-Dokumentation',
			'contact_dev' => 'Entwickler kontaktieren',
			'language' => 'Sprache',
			'report_bug' => 'Bug melden',
			'exit' => 'Sitzung beenden',
			'center' => 'Amomimus-Center',
			'support_queries' => 'Für Hilfe- und Supportanfragen',
			'help_support' => 'HILFE & SUPPORT',
			'public_name' => 'Öffentlicher Name',
			'privacy_settings' => 'Datenschutz & Einstellungen',
			'danger_zone' => 'Gefahrenzone',
			'delete_account_warning' => 'Das Löschen deines Accounts löscht dauerhaft alle lokalen Sitzungsdaten, Resonanzhistorien und gespeicherten Einstellungen. Diese Aktion kann nicht rückgängig gemacht werden.',
			'privacy' => 'Datenschutz',
			'about' => 'Über uns',
			'policy' => 'Richtlinien',
			'options' => 'Optionen',
			'how_it_works' => 'Wie Amomimus funktioniert',
			'report_bug_glitch' => 'Einen Bug / Fehler melden',
			'terms_of' => 'Nutzungsbedingungen von ',
			'privacy_rules_agreement' => 'Datenschutz & Regelvereinbarung',
			'privacy_rules_text' => 'Zuletzt aktualisiert: Mai 2026\n\n1. Bleib ein Geist\nDu bist hier ein Geist. Keine echten Namen, keine Telefonnummern und schon gar kein Leaken der Adresse deines Ex oder Social-Media-Accounts. Wir wollen, dass dieser Raum komplett losgelöst von deinem echten Drama ist.\n\nWenn du versehentlich deine wahre Identität preisgibst oder jemanden doxt, erwarte keine Warnung. Wir löschen diesen Beitrag schneller als du blinzeln kannst, und dein Zugang verschwindet möglicherweise gleich mit. Bleib zu 100 % inkognito.\n\n2. Sei kein Arschloch\nSich auskotzen? Cool. Weinen? Wir verstehen dich. Deinen Frust über deinen Job oder dein Leben abzulassen, ist genau der Grund, warum wir diese App entwickelt haben, also lass ruhig Dampf ab.\n\nAber direkte Hassrede, gezieltes Mobbing oder jemanden schikanieren, der ohnehin schon am Boden ist? Nein, das ist der schnellste Weg, rauszufliegen. Es gibt eine klare Grenze zwischen Frust ablassen und einem erbärmlichen Troll zu sein.\n\n3. Keine Vorratsspeicherung von Daten\nWir kaufen, verkaufen oder interessieren uns nicht einmal für deine persönlichen Daten. Was bei Amomimus passiert, bleibt bei Amomimus. Deine temporären Sitzungen sind verschlüsselt und werden regelmäßig komplett von unseren Servern gelöscht.\n\n4. Kein kommerzielles Spamming\nDiese Plattform wurde für menschliche Emotionen geschaffen, nicht um deine Krypto-Coins zu verkaufen, deinen Online-Shop zu bewerben oder Affiliate-Links zu spammen. Kommerzielle Werbung ohne Erlaubnis führt zu einem sofortigen Hardware-Bann.\n\n5. Altersbeschränkung\nNutzer müssen mindestens 18 Jahre alt sein, um an dieser blinden Community teilzunehmen. Die hier geteilten Inhalte können erwachsen, schwer und ungeschönt sein. Schütze deine eigene psychische Gesundheit, bevor du die Rants anderer liest.\n\n6. Haftungsausschluss zum Inhalt\nDir gehören die Worte, die du schreibst, aber durch das Posten hier gewährst du Amomimus ein nicht-exklusives Recht, sie anonym innerhalb der App-Oberfläche anzuzeigen. Wir werden deine Geschichten niemals als unser Firmeneigentum beanspruchen.\n\n7. Melde- und Moderationssystem\nSelbst Geister haben Grenzen. Wenn du einen Beitrag findest, der gegen unsere Sicherheitsrichtlinien verstößt, nutze sofort die Meldefunktion. Unser automatisiertes System und Moderatoren überprüfen Meldungen rund um die Uhr.\n\n8. Verbot illegaler Aktivitäten\nNutze diese App nicht, um jegliche Form illegaler Aktivitäten, physischer Gewalt oder realer Gefahren zu planen, zu koordinieren oder zu fördern. Wir halten uns an digitale Sicherheitsvorschriften und werden bei Verstößen streng durchgreifen.\n\n9. App-Analyse\nWir sammeln nur anonyme technische Protokolle (wie Absturzberichte, Gerätemodelle und Systemsprachen), um sicherzustellen, dass die App reibungslos auf deinem Handy läuft. Keines dieser Protokolle kann zu deiner wahren Identität zurückverfolgt werden.\n\n10. Änderungen der Bedingungen\nAmomimus behält sich das Recht vor, diese Regeln jederzeit zu aktualisieren, um sich an neue Gesetze oder Funktionen anzupassen. Die weitere Nutzung der App nach Aktualisierungen bedeutet, dass du den neuesten Geist-Protokollen zustimmst.',
			'system_language' => 'Amomimus Systemsprache:',
			'dob' => 'Geburtsdatum:',
			'dob_required' => '* Erforderlich – Sie müssen Ihr Geburtsdatum auswählen',
			'agreement_verified' => 'Vereinbarung überprüft',
			'ready_to_verify' => 'Sind Sie bereit, unsere Bedingungen zu überprüfen?',
			'age_warning' => 'Um Amomimus verwenden zu können, müssen Sie mindestens 18 Jahre alt sein.',
			'accept_continue' => 'Akzeptieren und fortfahren',
			'select_birthday_first' => 'Wählen Sie zunächst Ihren Geburtstag aus',
			'accept_terms_first' => 'Akzeptieren Sie zunächst die Bedingungen',
			'mobile_app' => 'Amomimus Mobile App',
			'app_desc' => 'Ein sicherer Raum für anonymes Auskotzen, konzipiert für digitale Katharsis.',
			'create_your' => 'Erstellen Sie Ihr',
			'anonymous_username_label' => 'ANONYMER BENUTZERNAME',
			'leave_blank_random' => 'Für einen zufälligen Namen leer lassen',
			'enter_username_hint' => 'Geben Sie Ihren Benutzernamen ein',
			'id_generator_title' => 'AMOMIMUS ID-GENERATOR',
			'random_generate_id' => 'Zufällig generierte ID:',
			'choose_avatar_title' => 'WÄHLEN SIE IHREN AMOMUS-AVATAR',
			'incomplete_selection' => 'Unvollständige Auswahl',
			'proceed' => 'Fortfahren',
			'choose_avatar_first' => 'Bitte wählen Sie zuerst Ihren Amomus-Avatar!',
			'incomplete_selection_desc_1' => 'Das hast du nicht',
			'incomplete_selection_desc_2' => '.\n\nSie werden nicht eingeschränkt, Ihr individueller Name wird Ihnen jedoch nicht angezeigt. Das System generiert stattdessen automatisch ein zufälliges Ergebnis. Möchten Sie fortfahren?',
			'you_found_easter_egg' => 'Du hast das Osterei gefunden',
			'developer' => 'Entwickler:',
			'skip' => 'Überspringen',
			'welcome_to' => 'Willkommen bei',
			'safe_space_desc' => 'Ein sicherer Ort, um Ihre Gedanken auszutauschen, Fragen zu stellen und mit anderen in Kontakt zu treten.',
			'identity_hidden_desc_1' => 'Ihre wahre Identität ist unter einem verborgen',
			'identity_hidden_desc_2' => 'Name.',
			'identity_protected_desc' => 'Wir sorgen dafür, dass Ihre Identität geschützt ist.\nChatten Sie frei, ohne sich Gedanken darüber machen zu müssen, wer auf der anderen Seite ist.',
			'intro_indicators' => 'Einführung in Amomimus-Indikatoren:',
			'neutral' => 'Neutral',
			'users_participate_normally' => 'Benutzer, die normal teilnehmen.',
			'amoral' => 'Amoralisch',
			'users_nonchalant' => 'oder lässige Benutzer, auf die man achten sollte.',
			'toxic' => 'Giftig',
			'users_flagged' => 'Von der Community markierte Benutzer.',
			'safe_and' => 'Sicher &',
			'respectful' => 'Respektvoll',
			'value_privacy_desc' => 'Wir legen Wert auf Privatsphäre und Freundlichkeit. Bitte befolgen Sie beim Erkunden unsere Community-Regeln.',
			'app_version' => 'App-Version:',
      'share_to_chat' => 'Im Chat teilen',
			'create_post' => 'Einen Post erstellen',
			'whats_on_your_mind' => 'Was geht dir durch den Kopf? (Anonym)',
			'send_post' => 'Posten',
			'notifications' => 'Benachrichtigungen',
			'no_notifications' => 'Noch keine Benachrichtigungen',
			'no_feeds' => 'Keine Feeds verfügbar.',
			'comments' => 'Kommentare',
			'no_comments' => 'Noch keine Kommentare. Sei der Erste!',
			'add_comment' => 'Kommentar hinzufügen...',
			'replying_to' => 'Antwort an',
			'chat_this_amomim' => 'Mit diesem Amomim chatten',
			'delete_post' => 'Diesen Post löschen',
			'hide_feed' => 'Diesen Feed verbergen',
			'report_amomim' => 'Diesen Amomim melden',
			'resonated' => 'Hat resoniert',
			'resonates' => 'Resoniert',
			'chat_req_pending' => 'Chat-Anfrage ausstehend...',
			'indicator_noise_limit' => 'Dein Amomimus-Indikator ist NOISE. Chat-Anfragen sind verboten.',
			'ghost_limit_reached' => 'GHOST-Indikator-Limit erreicht: 7 Chat-Anfragen pro Tag.',
			'initiate_chat' => 'Chat starten',
			'confirm_chat' => 'Möchtest du wirklich mit dem Autor dieses Posts chatten?\n\nSie werden dich sehen als ',
			'cancel' => 'Abbrechen',
			'send_request' => 'Anfrage senden',
			'chat_req_sent' => 'Chat-Anfrage gesendet!',
			'feed_hidden' => 'Feed verborgen.',
			'bio' => 'Bio',
			'no_bio_yet' => 'Noch keine Bio',
			'write_bio' => 'Schreibe deine Bio...',
			'select_date' => 'Datum auswählen',
			'ok' => 'OK',
			'error_format' => 'Ungültiges Format',
			'error_invalid' => 'Ungültiges Datum',
			'notif_resonate' => 'hat mit deinem Post resoniert',
			'notif_comment' => 'hat deinen Post kommentiert',
			'notif_reply' => 'hat auf deinen Kommentar geantwortet',
			'just_now' => 'Gerade eben',
			'bio_updated' => 'Bio aktualisiert!',
			'coins_redemption' => 'Münzen einlösen',
			'redeemed_100_coins' => '100 Münzen eingelöst!',
			'vault_merit' => 'Vault & Merit',
			'my_coins' => 'Meine Münzen',
			'owned' => 'Im Besitz',
			'sticker_stash' => 'Sticker-Vorrat',
			'amomimus_indicators' => 'Amomimus-Indikatoren:',
			'recent_resonates' => 'Kürzliche Resonanzen',
			'see_all' => 'Alle ansehen',
			'no_recent_resonates' => 'Keine kürzlichen Resonanzen.',
			'all_resonates' => 'Alle Resonanzen',
			'no_resonates_yet' => 'Noch keine Resonanzen',
			'delete_post_title' => 'Post löschen',
			'delete_post_confirm' => 'Möchtest du diesen Post wirklich löschen? Er wird endgültig aus dem Feed entfernt.',
			'delete_account' => 'Account löschen',
			'delete' => 'Löschen',
			'profile_locked' => 'Profil gesperrt',
			'locked_desc' => 'Du musst eine Chat-Verbindung mit diesem Nutzer aufbauen, um das vollständige Profil zu sehen.',
			'profile' => 'Profil',
			'no_active_user' => 'Kein aktiver Nutzer.',
			'incoming_requests' => 'Eingehende Anfragen',
			'no_incoming_requests' => 'Keine eingehenden Anfragen',
			'chat_req_accepted' => 'Chat-Anfrage akzeptiert!',
			'messages' => 'Nachrichten',
			'amomus_list' => 'Amomus-Liste',
			'switch_account' => 'Account wechseln',
			'no_accounts_registered' => 'Noch keine Accounts registriert.',
			'chat_requests' => 'Chat-Anfragen',
			'chat_request_title' => 'Chat-Anfrage',
			'chat_request_desc1' => 'Das Senden einer Chat-Anfrage an diesen Amomimus enthüllt deinen registrierten Nutzernamen "',
			'chat_request_desc2' => '" anstelle deines Feed-Namens "',
			'chat_request_desc3' => '".\n\nWenn sie akzeptieren, können sie außerdem dein Profil sehen.',
			'delete_chat_title' => 'Chat löschen',
			'delete_chat_confirm_prefix' => 'Möchtest du den Chat mit ',
			'delete_chat_confirm_suffix' => ' wirklich löschen?',
			'chat_deleted_prefix' => 'Chat mit ',
			'chat_deleted_suffix' => ' wurde gelöscht',
			'memories' => 'Erinnerungen',
			'no_memories_pinned' => 'Noch keine Erinnerungen angepinnt.',
			'delete_chat_room_confirm' => 'Möchtest du diesen Chat wirklich löschen?',
			'pin_limit_error' => 'Du kannst nur bis zu 9 Erinnerungen anpinnen. Entferne zuerst eine!',
			'write_message' => 'Nachricht schreiben...',
			'reply' => 'Antworten',
			'doc_title' => 'App-Dokumentation',
			'doc_category_legal' => 'Rechtliches & Datenschutzrichtlinie',
			'doc_rule_1_title' => '1. Datenerhebung',
			'doc_rule_1_desc' => 'Wir sammeln nur die minimal erforderlichen Daten für unsere Hauptfunktionen. Dein anonymer Identifikator ist nicht mit deiner persönlichen Identität verknüpft.',
			'doc_rule_2_title' => '2. Ende-zu-Ende-Verschlüsselung',
			'doc_rule_2_desc' => 'Alle Chat-Nachrichten sind Ende-zu-Ende verschlüsselt. Wir können deine privaten Nachrichten nicht lesen.',
			'doc_rule_3_title' => '3. Sitzungsdaten',
			'doc_rule_3_desc' => 'Lokale Sitzungsdaten werden sicher auf deinem Gerät gespeichert. Das Löschen deiner App-Daten löscht deine lokale Historie dauerhaft.',
			'doc_rule_4_title' => '4. Dienste Dritter',
			'doc_rule_4_desc' => 'Wir verkaufen oder teilen deine Daten nicht mit Dritten. Externe Integrationen dienen ausschließlich betrieblichen Zwecken.',
			'doc_rule_5_title' => '5. Haftung für Nutzerinhalte',
			'doc_rule_5_desc' => 'Du bist allein verantwortlich für die Inhalte, die du postest. Amomimus haftet nicht für nutzergenerierte Inhalte.',
			'doc_rule_6_title' => '6. Anonymitätsgarantie',
			'doc_rule_6_desc' => 'Deine öffentlichen Interaktionen bleiben anonym, es sei denn, du entscheidest dich ausdrücklich dafür, deine Identität über eine Chat-Anfrage preiszugeben.',
			'doc_rule_7_title' => '7. Accountlöschung',
			'doc_rule_7_desc' => 'Du hast jederzeit das Recht, deinen Account zu löschen. Dieser Vorgang ist irreversibel und löscht alle zugehörigen Daten.',
			'doc_rule_8_title' => '8. Belästigung & Missbrauch',
			'doc_rule_8_desc' => 'Wir dulden absolut keine Belästigung. Zuwiderhandlungen werden dauerhaft gebannt.',
			'doc_rule_9_title' => '9. Geistiges Eigentum',
			'doc_rule_9_desc' => 'Alle Originalressourcen, einschließlich Sticker und UI-Elemente, sind geistiges Eigentum von Amomimus.',
			'doc_rule_10_title' => '10. Richtlinien-Updates',
			'doc_rule_10_desc' => 'Wir behalten uns das Recht vor, diese Bedingungen zu aktualisieren. Die weitere Nutzung der App gilt als Annahme der neuen Bedingungen.',
			'unpin_memories' => 'Von Erinnerungen lösen',
			'pin_memories' => 'Zu Erinnerungen pinnen',
			'report' => 'Melden',
			'show_less' => 'Weniger anzeigen',
			'show_more' => 'Mehr anzeigen',
			'post_detail' => 'Post-Details',
			'sticker_shop' => 'Sticker-Shop',
			'view' => 'Ansehen',
			'buy' => 'Kaufen',
			'unlock_stickers' => 'Schalte hier deine Sticker frei',
			'includes_exclusive_items' => 'Enthält {count} exklusive Items',
			'stickers_inside' => '{count} {tier} Sticker enthalten.',
			'premium' => 'Premium',
			'already_own_batch' => 'Du besitzt dieses Paket bereits.',
			'not_enough_coins' => 'Nicht genug Münzen.',
			'emojis' => 'Emojis',
			'my_stickers' => 'Meine Sticker',
			'no_stickers_owned' => 'Noch keine Sticker im Besitz.',
			'sticker' => 'Sticker',
			'message_deleted' => 'Nachricht gelöscht',
			'my_sticker_stash' => 'Mein Sticker-Vorrat',
			'stash_empty' => 'Dein Vorrat ist leer.',
			'visit_sticker_shop' => 'Besuche den Shop, um dir ein paar Packs zu schnappen!',
			'stickers' => 'Sticker',
			'own_these_stickers' => 'Dir gehören diese Sticker.',
			'chosen_amomus_prefix' => 'Dein gewählter Amomus: ',
			'character_not_chosen' => 'Charakter noch nicht ausgewählt!',
			'press_back_again' => 'Drücke nochmal zurück, um zu beenden',
			'ex_blocked' => 'EHEMALS BLOCKIERT',
			'blocked_users' => 'Blockierte Benutzer',
			'previously_blocked' => 'Zuvor blockierte Benutzer',
			'no_blocked_users' => 'Du hast niemanden blockiert.',
			'splash_shutting_down' => 'HERUNTERFAHREN...',
			'splash_unplug' => 'ZIEHEN SIE DIE DYSTOPIE AUS',
			'splash_returning' => 'ZURÜCK ZUR REALITÄT',
			'splash_no_signal' => 'KEIN SIGNAL',
			'splash_stand_by' => 'STEHEN ZU...',
			'splash_embrace' => 'UMARME DEN LÄRM',
			'smileys_emotion' => 'Smileys & Emotionen',
			'people_body' => 'Menschen & Körper',
			'animals_nature' => 'Tiere & Natur',
			'food_drink' => 'Essen & Trinken',
			'no_previous_blocks' => 'Keine vorherigen Blockierungen.',
			'unblock' => 'Entblocken',
			'block_again' => 'Wieder blockieren',
			'error_loading_account_data' => 'Fehler beim Laden der Account-Daten.',
			'security_auth' => 'Sicherheit & Authentifizierung',
			'favorite_character' => 'Lieblingscharakter (2FA/Wiederherstellung)',
			'edit_max_1_day' => 'Bearbeiten (Max 1/Tag)',
			'forget_passcode' => 'Passcode vergessen',
			'reset_passcode_hint' => 'Benutze deinen Lieblingscharakter, um den Passcode zurückzusetzen.',
			'reset_passcode' => 'Passcode zurücksetzen',
			'share' => 'Teilen',
			'continue_btn' => 'Weiter',
			'validation_form' => 'Validierungsformular',
			_ => null,
		};
	}
}
