# MVRG APP / ACTIVEARN 
This project is blockchain based member motivation system. With this project, a sustainable member motivation and management system is aimed.

# Table of Contents
1. [ Project Description ](#ProjectDescription)
2. [ MvRG Token ](#MvRGToken)
3. [ System Model ](#SystemModel)
4. [ Implementation ](#Implementation)
5. [ Technologies ](#Technologies)
6. [ Team Members ](#TeamMembers)
7. [ Application Screenshots ](#Appss)
8. [ Setup ](#Setup)

<a name="ProjectDescription"></a>
## 1. Project Description
This Project will provide the research groups with the necessary member motivation to implement their activities. Sharing the app for free from app stores will increase accessibility. With the developed gamification, the contribution and commitment of the members to the research groups will increase. Members will earn tokens as a result of free events. They will spend these earned tokens to participate in paid special events. With this token economy, members will be connected to research groups and find the necessary motivation to participate in events. In this way, the system will be self-sustaining.

<a name="MvRGToken"></a>
## 2. MvRG Token
The MvRG Token created for this project is an ERC-20 token. Solidity software language was used for the development of the token. While creating the token, the [OpenZeppelin](https://github.com/OpenZeppelin/openzeppelin-contracts/tree/v4.0.0) ERC-20 Token is based. This ERC-20 Token is inherited while the MvRG Token was created. Remix IDE was also used to test the token. The MvRG Token has been deployed to the Goerli testnet with hardhat. After deploying to Goerli, hardhat gave the token address and token abi where we can interact with this token.

<a name="SystemModel"></a>
## 3. System Model

  ![image](https://github.com/MrBuluc/mvrg_app/assets/80323601/3af4bd2f-2632-45aa-8b54-cd6249c331db)

<a name="Implementation"></a>
## 4. Implementation
The MvRG Token created for this project is an ERC-20 token. Solidity software language was used for the development of the token. While creating the token, the OpenZeppelin ERC-20 Token [10] is based. This ERC-20 Token is inherited while the MvRG Token was created. Remix IDE was also used to test the token. The MvRG Token has been deployed to the Goerli testnet with hardhat. After deploying to Goerli, hardhat gave the token address and token abi where we can interact with this token. After we put this address and abi in a flutter project, we started to develop the design of our mobile application. We provided communication between Flutter and Token with web3dart flutter package.
<a name="Technologies"></a>
## 5. Technologies

<table style"float:right;">  
  <tr>  
    <td><img src="https://github.com/MrBuluc/mvrg_app/assets/80323601/dc8d4acc-01ec-47ba-b8e4-0a2fd5933786"/></td>
    <td><img src="https://github-production-user-asset-6210df.s3.amazonaws.com/80323601/246691066-f9215bf2-4a97-4605-8d5a-20fdd44b8f2f.png"></td>  
    <td><img src="https://github.com/MrBuluc/mvrg_app/assets/80323601/a5f756e1-2476-43a6-8b4c-1af2aa4d723d"/></td>  
  </tr>  
  <tr>  
    <td><img src="https://github.com/MrBuluc/mvrg_app/assets/80323601/453a12b6-5f09-438d-84b4-750c1128e3a0"/></td>  
    <td><img src="https://github.com/MrBuluc/mvrg_app/assets/80323601/98d253a3-b805-4ed1-844f-6ad91e788562"/></td>  
    <td><img src="https://github.com/MrBuluc/mvrg_app/assets/80323601/165e071a-5764-4c31-8690-4e93073c1483"/></td>  
  </tr>  
</table>

<a name="TeamMembers"></a>
## 6. Team Members
<table>
        <td align="center"><a href="https://github.com/MrBuluc"><img src="https://avatars.githubusercontent.com/u/43816007?s=400&u=d645bffeec22057c3b52ef818900fd7bdcc19eb0&v=4" width="100px;" alt=""/><br/><sub><b>Hakkıcan Bülüç</b></sub></a><br/><br/><sub><b>Smart Contract / Flutter Developer</b></sub></a><br/></a></td>
        <td align="center"><a href="https://github.com/helinkabak"><img src="https://avatars.githubusercontent.com/u/80323601?v=4" width="100px;" alt=""/><br/><sub><b>Helin Aylin Kabak</b></sub></a><br/><br/><sub><b>Flutter Developer</b></sub></a><br/></a></td>
</table>

<a name="Appss"></a>
## 7. Application Screenshots

<table style"float:right;">  
  <tr>  
    <td><img src="https://github.com/MrBuluc/mvrg_app/assets/80323601/00cf6620-0928-4060-8a07-e45e6faacdb6"/></td>
    <td><img src="https://github.com/MrBuluc/mvrg_app/assets/80323601/6ff896e1-65f3-4c15-a976-bb31be6e9df4"></td>  
    <td><img src="https://github.com/MrBuluc/mvrg_app/assets/80323601/fa85bb36-ddeb-4c7f-95ed-9c71c32256bc"/></td>  
  </tr>  
  <tr>  
    <td><img src="https://github.com/MrBuluc/mvrg_app/assets/80323601/901300a2-9d66-4c8a-ad2d-6e0e1d7f1ec0"/></td>  
    <td><img src="https://github.com/MrBuluc/mvrg_app/assets/80323601/9b94458c-88bc-4dd1-b219-9867a1545381"/></td>  
    <td><img src="https://github.com/MrBuluc/mvrg_app/assets/80323601/fadf4512-e262-431d-a3d4-3d2ad2162aa2"/></td>  
  </tr>  
</table>

<a name="Setup"></a>
## 8. Setup

To get started, install [Flutter version: 3.3.10](https://docs.flutter.dev/release/archive?tab=windows) and clone the repository.

To see if the conditions are met:
```bash
  flutter doctor
```

After the Flutter installation is done successfully, open the project in your favorite ide: [Android Studio](https://developer.android.com/studio) or [VS Code](https://code.visualstudio.com/download).

To install the required packages, in the terminal under the project directory:
```bash
  flutter pub get
```

After completing the emulator installation, run your emulator. You can launch the app via your favorite ide:

Android Studio -> Shift+F10

VS Code -> F5
