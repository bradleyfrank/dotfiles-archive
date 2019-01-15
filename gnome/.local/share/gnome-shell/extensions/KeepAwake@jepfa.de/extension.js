// Original author: Jens Pfahl

const St = imports.gi.St;
const Main = imports.ui.main;
const Tweener = imports.ui.tweener;
const Gio = imports.gi.Gio;
const Clutter = imports.gi.Clutter;
const IconTheme = imports.gi.Gtk.IconTheme;

const ExtensionUtils = imports.misc.extensionUtils;
const Me = ExtensionUtils.getCurrentExtension();
const Convenience = Me.imports.convenience;

const Gettext = imports.gettext.domain('KeepAwake');
const _ = Gettext.gettext;

const MODE_OFF = 0;
const MODE_ON = 1;

/*
 used system GSettings
 ---------------------
 org.gnome.settings-daemon.plugins.power:
 idle-dim                     bool    false
 sleep-inactive-ac-type       String  'nothing'
 sleep-inactive-battery-type  String  'nothing'

 org.gnome.desktop.session:
 idle-delay                   int32   0

 org.gnome.desktop.screensaver:
 idle-activation-enabled      bool    false
*/

const POWER_SCHEMA = 'org.gnome.settings-daemon.plugins.power';
const POWER_DIM_KEY = 'idle-dim';
const POWER_AC_KEY = 'sleep-inactive-ac-type';
const POWER_BAT_KEY = 'sleep-inactive-battery-type';
const RESTORE_STATE_KEY = 'restore-state';

const SESSION_SCHEMA = 'org.gnome.desktop.session';
const SESSION_DELAY_KEY = 'idle-delay';

const SCREENSAVER_SCHEMA = 'org.gnome.desktop.screensaver';
const SCREENSAVER_ACTIVATION_KEY = 'idle-activation-enabled';

const POWER_DIM_DEFAULT = false;
const POWER_AC_DEFAULT = 'nothing';
const POWER_BAT_DEFAULT = 'nothing';
const SESSION_DELAY_DEFAULT = 0;
const SCREENSAVER_ACTIVATION_DEFAULT = false;

// settings
let _powerSettings, _sessionSettings, _screensaverSettings, _extensionSettings;

// IU components
let _trayButton, _trayIconOn, _trayIconOff, _trayIconOnLock, _buttonPressEventId;

// 0 = video mode off --> system/monitor (possibly) suspends when idle
// 1 = video mode on --> system/monitor doesn't suspend when idle
let _mode;

let _lastPowerDim, _lastPowerAc, _lastPowerBat, _lastSessionDelay, _lastScreensaverActivation;
let _powerDimEventId, _powerAcEventId, _powerBatEventId, _sessionDelayEventId, _screensaverActivationEventId;

function getPowerDim() {
  return _powerSettings.get_boolean(POWER_DIM_KEY);
}

function setPowerDim(value) {
  _powerSettings.set_boolean(POWER_DIM_KEY, value);
}

function getPowerAc() {
  return _powerSettings.get_string(POWER_AC_KEY);
}

function setPowerAc(value) {
  _powerSettings.set_string(POWER_AC_KEY, value);
}

function getPowerBat() {
  return _powerSettings.get_string(POWER_BAT_KEY);
}

function setPowerBat(value) {
  _powerSettings.set_string(POWER_BAT_KEY, value);
}

function getStateRestore() {
  return _extensionSettings.get_boolean(RESTORE_STATE_KEY);
}

function setStateRestore(value) {
  _extensionSettings.set_boolean(RESTORE_STATE_KEY, value);
}

function getSessionDelay() {
  return _sessionSettings.get_uint(SESSION_DELAY_KEY);
}

function setSessionDelay(value) {
  _sessionSettings.set_uint(SESSION_DELAY_KEY, value);
}

function getScreensaverActivation() {
  return _screensaverSettings.get_boolean(SCREENSAVER_ACTIVATION_KEY);
}

function setScreensaverActivation(value) {
  _screensaverSettings.set_boolean(SCREENSAVER_ACTIVATION_KEY, value);
}

function enableVideoMode() {
  _lastPowerDim = getPowerDim();
  setPowerDim(POWER_DIM_DEFAULT);

  _lastPowerAc = getPowerAc();
  setPowerAc(POWER_AC_DEFAULT);

  _lastPowerBat = getPowerBat();
  setPowerBat(POWER_BAT_DEFAULT);

  _lastSessionDelay = getSessionDelay();
  setSessionDelay(SESSION_DELAY_DEFAULT);

  _lastScreensaverActivation = getScreensaverActivation();
  setScreensaverActivation(SCREENSAVER_ACTIVATION_DEFAULT);
}

function disableVideoMode() {
  setPowerDim(_lastPowerDim);
  setPowerAc(_lastPowerAc);
  setPowerBat(_lastPowerBat);
  setSessionDelay(_lastSessionDelay);
  setScreensaverActivation(_lastScreensaverActivation);
}

function isReadyForWatchingVideo() {
  return getPowerDim() == POWER_DIM_DEFAULT
    && getPowerAc() == POWER_AC_DEFAULT
    && getPowerBat() == POWER_BAT_DEFAULT
    && getSessionDelay() == SESSION_DELAY_DEFAULT
    && getScreensaverActivation() == SCREENSAVER_ACTIVATION_DEFAULT;
}


function toggleMode() {
  if (_mode == MODE_ON) {
    _mode = MODE_OFF;
    setStateRestore(true);
  } else if (_mode == MODE_OFF) {
    enableVideoMode();
    _mode = MODE_ON;
  }
}


function updateMode() {
  if (isReadyForWatchingVideo()) {
    _mode = MODE_ON;
  } else {
    _mode = MODE_OFF;
  }
}

function showModeTween() {
  let tweenText;

  if (_mode == MODE_ON) {
    tweenText = new St.Label({ style_class: 'video-label-on', text: _("Enabled") });
  } else if (_mode == MODE_OFF) {
    tweenText = new St.Label({ style_class: 'video-label-off', text: _("Disabled") });
  }

  Main.uiGroup.add_actor(tweenText);

  let monitor = Main.layoutManager.primaryMonitor;

  tweenText.set_position(monitor.x + Math.floor(monitor.width / 2 - tweenText.width / 2),
    monitor.y + Math.floor(monitor.height / 2 - tweenText.height / 2));

  Tweener.addTween(tweenText, {
    opacity: 0,
    time: 4,
    transition: 'easeOutQuad',
    onComplete: function() { hideModeTween(tweenText); }
  });
}

function hideModeTween(tweenText) {
  Main.uiGroup.remove_actor(tweenText);
}

function updateIcon() {
  if (_mode == MODE_ON) {
    _trayButton.set_child( _mode == MODE_ON ? _trayIconOn : _trayIconOnLock);
  } else if (_mode == MODE_OFF) {
    _trayButton.set_child(_trayIconOff);
  }
}

function _handleIconClicked() {
  toggleMode();
  updateIcon();
  showModeTween();
}


function _reflectChanges() {
  // we save the reflective user settings or the extension settings,
  // because when this extension terminated without calling disable(), we can restore the original user settings

  if (getPowerDim() != POWER_DIM_DEFAULT) { // the user changed the settings, we came probably not from enableVideoMode()
    _lastPowerDim = getPowerDim;
  }

  if (getPowerAc() != POWER_AC_DEFAULT) { // the user changed the settings, we came probably not from enableVideoMode()
    _lastPowerAc = getPowerAc();
  }

  if (getPowerBat() != POWER_BAT_DEFAULT) { // the user changed the settings, we came probably not from enableVideoMode()
    _lastPowerBat = getPowerBat();
  }

  if (getSessionDelay() != SESSION_DELAY_DEFAULT) { // the user changed the settings, we came probably not from enableVideoMode()
    _lastSessionDelay = getSessionDelay();
  }

  if (getScreensaverActivation() != SCREENSAVER_ACTIVATION_DEFAULT) { // the user changed the settings, we came probably not from enableVideoMode()
    _lastScreensaverActivation = getScreensaverActivation();
  }

  _extensionSettings.set_boolean(POWER_DIM_KEY, _lastPowerDim);
  _extensionSettings.set_string(POWER_AC_KEY, _lastPowerAc);
  _extensionSettings.set_string(POWER_BAT_KEY, _lastPowerBat);
  _extensionSettings.set_int(SESSION_DELAY_KEY, _lastSessionDelay);
  _extensionSettings.set_boolean(SCREENSAVER_ACTIVATION_KEY, _lastScreensaverActivation);

  // update UI
  updateMode();
  updateIcon();
}

function init() {
  Convenience.initTranslations("KeepAwake");

  let theme = IconTheme.get_default();
  theme.append_search_path(Me.path + "/icons");

  _trayButton = new St.Bin({ style_class: 'panel-button',
    reactive: true,
    can_focus: true,
    x_fill: true,
    y_fill: false,
    track_hover: true });
  _trayIconOn = new St.Icon({ icon_name: 'my-caffeine-on-symbolic',
    style_class: 'system-status-icon' });
  _trayIconOff = new St.Icon({ icon_name: 'my-caffeine-off-symbolic',
    style_class: 'system-status-icon' });

  // init GSettings
  _powerSettings = new Gio.Settings({ schema_id: POWER_SCHEMA });
  _sessionSettings = new Gio.Settings({ schema_id: SESSION_SCHEMA });
  _screensaverSettings = new Gio.Settings({ schema_id: SCREENSAVER_SCHEMA });
  _extensionSettings = Convenience.getSettings();
}

function enable() {
  // Before connect to _reflectChanges(), we restore the last saved settings to the user settings, if they are not disturbing.
  // The reason is, when the user shutdown the system or loggod off, disable() is obviously not called to call disableVideoMode().
  if (isReadyForWatchingVideo()) {
    // load last saved extension settings
    _lastPowerDim = _extensionSettings.get_boolean(POWER_DIM_KEY);
    _lastPowerAc = _extensionSettings.get_string(POWER_AC_KEY);
    _lastPowerBat = _extensionSettings.get_string(POWER_BAT_KEY);
    _lastSessionDelay = _extensionSettings.get_int(SESSION_DELAY_KEY);
    _lastScreensaverActivation = _extensionSettings.get_boolean(SCREENSAVER_ACTIVATION_KEY);

    setPowerDim(_lastPowerDim);
    setPowerAc(_lastPowerAc);
    setPowerBat(_lastPowerBat);
    setSessionDelay(_lastSessionDelay);
    setScreensaverActivation(_lastScreensaverActivation);
  } else {
    // load current user settings
    _lastPowerDim = getPowerDim();
    _lastPowerAc = getPowerAc();
    _lastPowerBat = getPowerBat();
    _lastSessionDelay = getSessionDelay();
    _lastScreensaverActivation = getScreensaverActivation();
  }

  // reflect settings changes
  _powerDimEventId = _powerSettings.connect('changed::'+POWER_DIM_KEY,  _reflectChanges);
  _powerAcEventId = _powerSettings.connect('changed::'+POWER_AC_KEY,  _reflectChanges);
  _powerBatEventId = _powerSettings.connect('changed::'+POWER_BAT_KEY,  _reflectChanges);
  _sessionDelayEventId =_sessionSettings.connect('changed::'+SESSION_DELAY_KEY,  _reflectChanges);
  _screensaverActivationEventId = _screensaverSettings.connect('changed::'+SCREENSAVER_ACTIVATION_KEY,  _reflectChanges);

  // enable UI
  Main.panel._rightBox.insert_child_at_index(_trayButton, 0);

  _buttonPressEventId = _trayButton.connect('button-press-event', _handleIconClicked);

  // restore previous state
  if (getStateRestore() === true) {
    enableVideoMode();
  }

  updateMode();
  updateIcon();
}


function disable() {
  disableVideoMode();
  _trayButton.disconnect(_buttonPressEventId);
  Main.panel._rightBox.remove_child(_trayButton);

  _powerSettings.disconnect(_powerDimEventId);
  _powerSettings.disconnect(_powerAcEventId);
  _powerSettings.disconnect(_powerBatEventId);
  _sessionSettings.disconnect(_sessionDelayEventId);
  _screensaverSettings.disconnect(_screensaverActivationEventId);

  // set extension settings to default
  _extensionSettings.set_boolean(POWER_DIM_KEY, POWER_DIM_DEFAULT);
  _extensionSettings.set_string(POWER_AC_KEY, POWER_AC_DEFAULT);
  _extensionSettings.set_string(POWER_BAT_KEY, POWER_BAT_DEFAULT);
  _extensionSettings.set_int(SESSION_DELAY_KEY, SESSION_DELAY_DEFAULT);
  _extensionSettings.set_boolean(SCREENSAVER_ACTIVATION_KEY, SCREENSAVER_ACTIVATION_DEFAULT);
}