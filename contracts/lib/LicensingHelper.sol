// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import { ILicenseRegistry } from "@storyprotocol/core/interfaces/registries/ILicenseRegistry.sol";
import { ILicensingModule } from "@storyprotocol/core/interfaces/modules/licensing/ILicensingModule.sol";
import { IPILicenseTemplate, PILTerms } from "@storyprotocol/core/interfaces/modules/licensing/IPILicenseTemplate.sol";

/// @title Periphery Licensing Helper Library
/// @notice Library for all licensing related helper functions for Periphery contracts.
library LicensingHelper {
    /// @dev Registers PIL License Terms and attaches them to the given IP.
    /// @param ipId The ID of the IP.
    /// @param pilTemplate The address of the PIL License Template.
    /// @param licensingModule The address of the Licensing Module.
    /// @param licenseRegistry The address of the License Registry.
    /// @param terms The PIL terms to be registered.
    /// @return licenseTermsId The ID of the registered PIL terms.
    function registerPILTermsAndAttach(
        address ipId,
        address pilTemplate,
        address licensingModule,
        address licenseRegistry,
        PILTerms calldata terms
    ) internal returns (uint256 licenseTermsId) {
        licenseTermsId = IPILicenseTemplate(pilTemplate).registerLicenseTerms(terms);

        attachLicenseTerms(ipId, licensingModule, licenseRegistry, pilTemplate, licenseTermsId);
    }

    /// @dev Attaches license terms to the given IP.
    /// @param ipId The ID of the IP.
    /// @param licensingModule The address of the Licensing Module.
    /// @param licenseRegistry The address of the License Registry.
    /// @param licenseTemplate The address of the license template.
    /// @param licenseTermsId The ID of the license terms to be attached.
    function attachLicenseTerms(
        address ipId,
        address licensingModule,
        address licenseRegistry,
        address licenseTemplate,
        uint256 licenseTermsId
    ) internal {
        // Returns if license terms are already attached.
        if (ILicenseRegistry(licenseRegistry).hasIpAttachedLicenseTerms(ipId, licenseTemplate, licenseTermsId)) return;

        ILicensingModule(licensingModule).attachLicenseTerms(ipId, licenseTemplate, licenseTermsId);
    }
}
