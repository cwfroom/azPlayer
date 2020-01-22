import React, {Component} from 'react'
import { AppRegistry } from 'react-native'
import { Provider as PaperProvider } from 'react-native-paper'
import { BottomNavigation } from 'react-native-paper'
import LibraryView from './components/views/LibraryView'
import PlayerView from './components/views/PlayerView'

export default class App extends Component{
  state = {
    index: 0,
    routes: [
      { key: 'library', title: 'Library', icon: 'album'},
      { key: 'player', title: 'Player', icon: 'play_circle_filled'}  
    ]
  }

  handleNavIndexChange = (index) => {
    this.setState({index})
  }

  renderScene = BottomNavigation.SceneMap({
    library: LibraryView,
    player: PlayerView,
  })
  
  render() {
    return (
      <PaperProvider>
        <BottomNavigation
          navigationState={this.state}
          onIndexChange={this.handleNavIndexChange}
          renderScene={this.renderScene}
        ></BottomNavigation>
      </PaperProvider>
    )
  }
}

AppRegistry.registerComponent('app', () => App);