/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 *
 * @format
 */

import React from 'react';
import {StyleSheet, View, requireNativeComponent} from 'react-native';

// requireNativeComponent automatically resolves 'RNTMap' to 'RNTMapManager'
const ScrollView = requireNativeComponent('ScrollList');

function App(): JSX.Element {
  return (
    <View style={styles.container}>
      <ScrollView style={{ flex: 1 }}/>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    paddingHorizontal: 20,
    paddingVertical: 50,
    // backgroundColor: 'green',
  },
  pressStyle: {
    width: '100%',
    height: 52,
    backgroundColor: 'blue',
    justifyContent: 'center',
    alignItems: 'center',
  },
});

export default App;
