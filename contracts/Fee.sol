// Contract Name: Fee
//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.1;

import "@openzeppelin/contracts/access/AccessControl.sol";


contract Fee is AccessControl {

    bytes32 public constant FEE_CHANGER_ROLE = keccak256("FEE_CHANGER");
    
    //  successful case fees
    uint256 private bookingPercentage;
    uint256 private platformFeePercentage;
    uint256 private administrativeFeePercentage;
    uint256 private dldFeePercentage;
    uint256 private poaFee;
    
    // // unsuccessful case fees: booking time passed
    // uint256 private platformFeeBookingPassedPercentage;
    // uint256 private agencyFeeBookingPassedPercentage;
    // uint256 private sellerFeeBookingPassedPercentage;

    

    // booking = 10%
    // remaining = 90%
    // platformFee = 5%
    // administrativeFee = 5%
    // DLD fee = 4%
    // PoA = 1000$

    // 100% = 10000
    // 10% = 1000
    // 5% = 500
    // 4% = 400

    event BookingPercentageChanged(uint256 newPercentage, uint256 timestamp);
    event PlatformFeePercentageChanged(uint256 newPercentage, uint256 timestamp);
    event AdministrativeFeePercentageChanged(uint256 newPercentage, uint256 timestamp);
    event DLDFeePercentageChanged(uint256 newPercentage, uint256 timestamp);
    event PoaFeeChanged(uint256 newFee, uint256 timestamp);

    constructor() {
        _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
    }

    modifier checkPercentage(uint256 _percentage) {
        require(_percentage <= 10000, "Percentage must be less than or equal to 100");
        require(_percentage >= 0);
        _;
    }

    function setFeeChanger(address _feeChanger) public onlyRole(DEFAULT_ADMIN_ROLE) {
        _setupRole(FEE_CHANGER_ROLE, _feeChanger);
    }

    function setFeePercentage(uint256 _booking, uint256 _platform, uint256 _administrative, uint256 _dld) public onlyRole(FEE_CHANGER_ROLE) checkPercentage(_booking) checkPercentage(_platform) checkPercentage(_administrative) checkPercentage(_dld) {
        uint256 sum = _booking + _platform + _administrative + _dld;
        
        require(sum <= 10000, "Percentage must be lte 100");

        bookingPercentage = _booking;
        platformFeePercentage = _platform;
        administrativeFeePercentage = _administrative;
        dldFeePercentage = _dld;
        
        uint256 bt = block.timestamp;
        emit BookingPercentageChanged(_booking, bt);
        emit PlatformFeePercentageChanged(_platform, bt);
        emit AdministrativeFeePercentageChanged(_administrative, bt);
        emit DLDFeePercentageChanged(_dld, bt);
    }

    // function setBookingPercentage(uint256 _percentage) public onlyRole(FEE_CHANGER_ROLE) checkPercentage(_percentage) {
    //     bookingPercentage = _percentage;
    //     emit BookingPercentageChanged(bookingPercentage, block.timestamp);
    // }

    // function setPlatformFeePercentage(uint256 _percentage) public onlyRole(FEE_CHANGER_ROLE) checkPercentage(_percentage) {
    //     platformFeePercentage = _percentage;
    //     emit PlatformFeePercentageChanged(platformFeePercentage, block.timestamp);
    // }

    // function setAdministrativeFeePercentage(uint256 _percentage) public onlyRole(FEE_CHANGER_ROLE) checkPercentage(_percentage) {
    //     administrativeFeePercentage = _percentage;
    //     emit AdministrativeFeePercentageChanged(administrativeFeePercentage, block.timestamp);
    // }

    // function setDLDFeePercentage(uint256 _percentage) public onlyRole(FEE_CHANGER_ROLE) checkPercentage(_percentage) {
    //     dldFeePercentage = _percentage;
    //     emit DLDFeePercentageChanged(dldFeePercentage, block.timestamp);
    // }

    function setPoaFee(uint256 _fee) public onlyRole(FEE_CHANGER_ROLE) {
        poaFee = _fee;
        emit PoaFeeChanged(poaFee, block.timestamp);
    }

    function getBookingPercentage() public view returns (uint256) {
        return bookingPercentage;
    }

    function getPlatformFeePercentage() public view returns (uint256) {
        return platformFeePercentage;
    }

    function getAdministrativeFeePercentage() public view returns (uint256) {
        return administrativeFeePercentage;
    }

    function getDLDFeePercentage() public view returns (uint256) {
        return dldFeePercentage;
    }

    function getPoaFee() public view returns (uint256) {
        return poaFee;
    }

    function getBookingFee(uint256 _amount) public view returns (uint256) {
        return _amount * bookingPercentage / 10000;
    }

    function getPlatformFee(uint256 _amount) public view returns (uint256) {
        return _amount * platformFeePercentage / 10000;
    }

    function getAdministrativeFee(uint256 _amount) public view returns (uint256) {
        return _amount * administrativeFeePercentage / 10000;
    }

    function getDLDFee(uint256 _amount) public view returns (uint256) {
        return _amount * dldFeePercentage / 10000;
    }
}