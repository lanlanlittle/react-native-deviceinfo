
# react-native-deviceinfo

## Getting started

`$ npm install react-native-deviceinfo --save`

### Mostly automatic installation

`$ react-native link react-native-deviceinfo`

### Manual installation


#### iOS

1. In XCode, in the project navigator, right click `Libraries` ➜ `Add Files to [your project's name]`
2. Go to `node_modules` ➜ `react-native-deviceinfo` and add `RNDeviceinfo.xcodeproj`
3. In XCode, in the project navigator, select your project. Add `libRNDeviceinfo.a` to your project's `Build Phases` ➜ `Link Binary With Libraries`
4. Run your project (`Cmd+R`)<

#### Android

1. Open up `android/app/src/main/java/[...]/MainActivity.java`
  - Add `import com.zxx.deviceinfo.RNDeviceinfoPackage;` to the imports at the top of the file
  - Add `new RNDeviceinfoPackage()` to the list returned by the `getPackages()` method
2. Append the following lines to `android/settings.gradle`:
  	```
  	include ':react-native-deviceinfo'
  	project(':react-native-deviceinfo').projectDir = new File(rootProject.projectDir, 	'../node_modules/react-native-deviceinfo/android')
  	```
3. Insert the following lines inside the dependencies block in `android/app/build.gradle`:
  	```
      compile project(':react-native-deviceinfo')
  	```


## Usage
```javascript
import RNDeviceinfo from 'react-native-deviceinfo';

// TODO: What to do with the module?
RNDeviceinfo;
```
  