/**
 * @file
 * @copyright 2020 Aleksej Komarov
 * @license MIT
 */

import {
  changeSettingsTab,
  loadSettings,
  openChatSettings,
  toggleSettings,
  updateSettings,
} from './actions';
import { FONTS, SETTINGS_TABS } from './constants';
import { storage } from 'common/storage';

const initialState = {
  version: 1,
  fontSize: 13,
  fontFamily: FONTS[0],
  lineHeight: 1.2,
  theme: 'light',
  adminMusicVolume: 0.5,
  highlightText: '',
  highlightColor: '#ffdd44',
  matchWord: false,
  matchCase: false,
  view: {
    visible: false,
    activeTab: SETTINGS_TABS[0].id,
  },
  // Chat persistence setting - default is false, but use stored value if available
  chatSaving: storage.get('chat-saving-enabled') === true,
};

export const settingsReducer = (state = initialState, action) => {
  const { type, payload } = action;
  if (type === updateSettings.type) {
    return {
      ...state,
      ...payload,
    };
  }
  if (type === loadSettings.type) {
    // Validate version and/or migrate state
    if (!payload?.version) {
      return state;
    }
    delete payload.view;
    return {
      ...state,
      ...payload,
    };
  }
  if (type === toggleSettings.type) {
    return {
      ...state,
      view: {
        ...state.view,
        visible: !state.view.visible,
      },
    };
  }
  if (type === openChatSettings.type) {
    return {
      ...state,
      view: {
        ...state.view,
        visible: true,
        activeTab: 'chatPage',
      },
    };
  }
  if (type === changeSettingsTab.type) {
    const { tabId } = payload;
    return {
      ...state,
      view: {
        ...state.view,
        activeTab: tabId,
      },
    };
  }
  return state;
};
