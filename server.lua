-- MyHandling Client Script
-- AAA Vehicle Handling Editor for FiveM

local isEditorOpen = false
local currentVehicle = nil

-- Preset configurations
local presets = {
    sport = {
        name = "Sport Setup",
        description = "High-performance track-ready setup",
        config = {
            suspension = {
                compressionDamping = 2.5,
                reboundDamping = 3.0,
                springStrength = 8.0,
                rideHeight = -0.05,
                antiRollBar = 1.5
            },
            braking = {
                brakePower = 1.2,
                brakeBalance = 0.55,
                handbrakeForce = 1.5
            },
            traction = {
                tractionCurveMax = 2.8,
                tractionCurveMin = 2.5,
                tractionLoss = 0.9,
                lowSpeedTraction = 2.2
            },
            transmission = {
                driveInertia = 0.8,
                clutchChangeRate = 2.5,
                initialDriveForce = 0.35
            },
            engine = {
                acceleration = 0.35,
                topSpeed = 1.2,
                torque = 1.3,
                power = 1.25
            }
        }
    },
    street = {
        name = "Street Setup",
        description = "Balanced daily driver configuration",
        config = {
            suspension = {
                compressionDamping = 1.8,
                reboundDamping = 2.2,
                springStrength = 6.0,
                rideHeight = 0.0,
                antiRollBar = 1.0
            },
            braking = {
                brakePower = 1.0,
                brakeBalance = 0.5,
                handbrakeForce = 1.2
            },
            traction = {
                tractionCurveMax = 2.5,
                tractionCurveMin = 2.2,
                tractionLoss = 0.85,
                lowSpeedTraction = 2.0
            },
            transmission = {
                driveInertia = 1.0,
                clutchChangeRate = 2.0,
                initialDriveForce = 0.28
            },
            engine = {
                acceleration = 0.28,
                topSpeed = 1.0,
                torque = 1.0,
                power = 1.0
            }
        }
    },
    offroad = {
        name = "Off-Road Setup",
        description = "High clearance with improved traction",
        config = {
            suspension = {
                compressionDamping = 1.5,
                reboundDamping = 1.8,
                springStrength = 4.5,
                rideHeight = 0.1,
                antiRollBar = 0.7
            },
            braking = {
                brakePower = 0.9,
                brakeBalance = 0.45,
                handbrakeForce = 1.8
            },
            traction = {
                tractionCurveMax = 3.0,
                tractionCurveMin = 2.8,
                tractionLoss = 0.7,
                lowSpeedTraction = 2.5
            },
            transmission = {
                driveInertia = 1.2,
                clutchChangeRate = 1.8,
                initialDriveForce = 0.32
            },
            engine = {
                acceleration = 0.30,
                topSpeed = 0.9,
                torque = 1.4,
                power = 1.1
            }
        }
    }
}

-- Open Handling Editor
function openHandlingEditor()
    local playerPed = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(playerPed, false)
    
    if vehicle == 0 then
        exports['ox_lib']:notify({
            title = 'Handling Editor',
            description = 'You must be in a vehicle!',
            type = 'error'
        })
        return
    end
    
    currentVehicle = vehicle
    isEditorOpen = true
    
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = "SHOW_UI",
        data = {
            vehicle = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)),
            handling = getVehicleHandling(vehicle)
        }
    })
end

-- Close Handling Editor
function closeHandlingEditor()
    isEditorOpen = false
    currentVehicle = nil
    
    SetNuiFocus(false, false)
    SendNUIMessage({
        action = "HIDE_UI"
    })
end

-- Fetch Vehicle Data
function fetchVehicleData()
    if not currentVehicle or not DoesEntityExist(currentVehicle) then
        return nil
    end
    
    return {
        vehicle = GetDisplayNameFromVehicleModel(GetEntityModel(currentVehicle)),
        model = GetEntityModel(currentVehicle),
        handling = getVehicleHandling(currentVehicle)
    }
end

-- Get Vehicle Handling Data
function getVehicleHandling(vehicle)
    if not vehicle or vehicle == 0 then
        return nil
    end
    
    return {
        suspension = {
            compressionDamping = GetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fSuspensionCompDamp'),
            reboundDamping = GetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fSuspensionReboundDamp'),
            springStrength = GetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fSuspensionForce'),
            rideHeight = GetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fSuspensionRaise'),
            antiRollBar = GetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fAntiRollBarForce')
        },
        braking = {
            brakePower = GetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fBrakeForce'),
            brakeBalance = GetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fBrakeBiasFront'),
            handbrakeForce = GetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fHandBrakeForce')
        },
        traction = {
            tractionCurveMax = GetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fTractionCurveMax'),
            tractionCurveMin = GetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fTractionCurveMin'),
            tractionLoss = GetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fTractionLossMult'),
            lowSpeedTraction = GetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fLowSpeedTractionLossMult')
        },
        transmission = {
            driveInertia = GetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fDriveInertia'),
            clutchChangeRate = GetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fClutchChangeRateScaleUpShift'),
            initialDriveForce = GetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fInitialDriveForce')
        },
        engine = {
            acceleration = GetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fInitialDriveForce'),
            topSpeed = GetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fInitialDriveMaxFlatVel') / 150.0,
            torque = GetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fDriveBiasFront'),
            power = GetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fInitialDriveForce')
        }
    }
end

-- Apply Handling Configuration
function applyHandling(config)
    if not currentVehicle or not DoesEntityExist(currentVehicle) then
        return false, "Vehicle no longer exists"
    end
    
    if not validateHandlingData(config) then
        return false, "Invalid handling configuration"
    end
    
    -- Apply suspension
    if config.suspension then
        SetVehicleHandlingFloat(currentVehicle, 'CHandlingData', 'fSuspensionCompDamp', config.suspension.compressionDamping + 0.0)
        SetVehicleHandlingFloat(currentVehicle, 'CHandlingData', 'fSuspensionReboundDamp', config.suspension.reboundDamping + 0.0)
        SetVehicleHandlingFloat(currentVehicle, 'CHandlingData', 'fSuspensionForce', config.suspension.springStrength + 0.0)
        SetVehicleHandlingFloat(currentVehicle, 'CHandlingData', 'fSuspensionRaise', config.suspension.rideHeight + 0.0)
        SetVehicleHandlingFloat(currentVehicle, 'CHandlingData', 'fAntiRollBarForce', config.suspension.antiRollBar + 0.0)
    end
    
    -- Apply braking
    if config.braking then
        SetVehicleHandlingFloat(currentVehicle, 'CHandlingData', 'fBrakeForce', config.braking.brakePower + 0.0)
        SetVehicleHandlingFloat(currentVehicle, 'CHandlingData', 'fBrakeBiasFront', config.braking.brakeBalance + 0.0)
        SetVehicleHandlingFloat(currentVehicle, 'CHandlingData', 'fHandBrakeForce', config.braking.handbrakeForce + 0.0)
    end
    
    -- Apply traction
    if config.traction then
        SetVehicleHandlingFloat(currentVehicle, 'CHandlingData', 'fTractionCurveMax', config.traction.tractionCurveMax + 0.0)
        SetVehicleHandlingFloat(currentVehicle, 'CHandlingData', 'fTractionCurveMin', config.traction.tractionCurveMin + 0.0)
        SetVehicleHandlingFloat(currentVehicle, 'CHandlingData', 'fTractionLossMult', config.traction.tractionLoss + 0.0)
        SetVehicleHandlingFloat(currentVehicle, 'CHandlingData', 'fLowSpeedTractionLossMult', config.traction.lowSpeedTraction + 0.0)
    end
    
    -- Apply transmission
    if config.transmission then
        SetVehicleHandlingFloat(currentVehicle, 'CHandlingData', 'fDriveInertia', config.transmission.driveInertia + 0.0)
        SetVehicleHandlingFloat(currentVehicle, 'CHandlingData', 'fClutchChangeRateScaleUpShift', config.transmission.clutchChangeRate + 0.0)
        SetVehicleHandlingFloat(currentVehicle, 'CHandlingData', 'fInitialDriveForce', config.transmission.initialDriveForce + 0.0)
    end
    
    -- Apply engine
    if config.engine then
        SetVehicleHandlingFloat(currentVehicle, 'CHandlingData', 'fInitialDriveForce', config.engine.acceleration + 0.0)
        SetVehicleHandlingFloat(currentVehicle, 'CHandlingData', 'fInitialDriveMaxFlatVel', config.engine.topSpeed * 150.0)
    end
    
    return true, "Handling applied successfully"
end

-- Validate Handling Data
function validateHandlingData(data)
    if type(data) ~= "table" then
        return false
    end
    
    -- Basic validation - check if values are within reasonable ranges
    if data.suspension then
        if data.suspension.compressionDamping and (data.suspension.compressionDamping < 0 or data.suspension.compressionDamping > 10) then
            return false
        end
    end
    
    if data.braking then
        if data.braking.brakePower and (data.braking.brakePower < 0 or data.braking.brakePower > 5) then
            return false
        end
    end
    
    return true
end

-- NUI Callbacks
RegisterNUICallback('applyHandling', function(data, cb)
    local success, message = applyHandling(data.config)
    
    if success then
        SendNUIMessage({
            action = "SHOW_NOTIFICATION",
            data = {
                type = "success",
                title = "Success",
                message = message
            }
        })
    else
        SendNUIMessage({
            action = "SHOW_NOTIFICATION",
            data = {
                type = "error",
                title = "Error",
                message = message
            }
        })
    end
    
    cb({ success = success, message = message })
end)

RegisterNUICallback('closeUI', function(data, cb)
    closeHandlingEditor()
    cb({ success = true })
end)

RegisterNUICallback('getVehicleData', function(data, cb)
    local vehicleData = fetchVehicleData()
    
    if vehicleData then
        cb({ success = true, data = vehicleData })
    else
        cb({ success = false, message = "No vehicle found" })
    end
end)

RegisterNUICallback('getPresets', function(data, cb)
    cb({ success = true, data = presets })
end)

RegisterNUICallback('applyPreset', function(data, cb)
    local presetName = data.preset
    local preset = presets[presetName]
    
    if not preset then
        cb({ success = false, message = "Preset not found" })
        return
    end
    
    local success, message = applyHandling(preset.config)
    cb({ success = success, message = message })
end)

-- Command Registration
RegisterCommand('tuneditor', function()
    openHandlingEditor()
end, false)

RegisterCommand('tuneclose', function()
    closeHandlingEditor()
end, false)

-- Exports
exports('openHandlingEditor', openHandlingEditor)
exports('closeHandlingEditor', closeHandlingEditor)
exports('applyHandling', applyHandling)
exports('getVehicleHandling', getVehicleHandling)

-- Cleanup on resource stop
AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then
        return
    end
    
    if isEditorOpen then
        closeHandlingEditor()
    end
end)
