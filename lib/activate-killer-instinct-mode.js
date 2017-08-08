'use babel';

import ActivateKillerInstinctModeView from './activate-killer-instinct-mode-view';
import { CompositeDisposable } from 'atom';

export default {

  activateKillerInstinctModeView: null,
  modalPanel: null,
  subscriptions: null,

  activate(state) {
    this.activateKillerInstinctModeView = new ActivateKillerInstinctModeView(state.activateKillerInstinctModeViewState);
    this.modalPanel = atom.workspace.addModalPanel({
      item: this.activateKillerInstinctModeView.getElement(),
      visible: false
    });

    // Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    this.subscriptions = new CompositeDisposable();

    // Register command that toggles this view
    this.subscriptions.add(atom.commands.add('atom-workspace', {
      'activate-killer-instinct-mode:toggle': () => this.toggle()
    }));
  },

  deactivate() {
    this.modalPanel.destroy();
    this.subscriptions.dispose();
    this.activateKillerInstinctModeView.destroy();
  },

  serialize() {
    return {
      activateKillerInstinctModeViewState: this.activateKillerInstinctModeView.serialize()
    };
  },

  toggle() {
    console.log('ActivateKillerInstinctMode was toggled!');
    return (
      this.modalPanel.isVisible() ?
      this.modalPanel.hide() :
      this.modalPanel.show()
    );
  }

};
