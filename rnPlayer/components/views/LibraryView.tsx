
import React, { Component } from 'react'
import { View } from 'react-native'
import { Text } from 'react-native-paper'

export default class LibraryView extends Component {
    constructor (props) {
        super(props)
    }
    
    render () {
        return (
            <View>
                <Text>Library</Text>
            </View>
        )
    }
}