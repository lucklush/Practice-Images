# Define the admin and user lists
$admins = @("donkey", "kataraa", "sokkaa", "topha", "zukoa", "iroha")
$users = @("appaa", "momoa", "sukia", "bumia", "hakodaa", "jeongjeonga", "pakkua", "piandaoa", "maia", "tyleea", "tyroa", "jeta", "longshota", "smellerbeea", "gurupathika", "huua", "thoa", "duea", "yuea", "yagodaa")

# Specify the groups in Active Directory
$adminGroup = "Domain Admins"  # Replace with your admin group name if it's different
$userGroup = "Domain Users"    # Replace with your user group name if it's different

# Function to add users to a group
function Add-UserToGroup($usersList, $group) {
    foreach ($user in $usersList) {
        try {
            # Check if user exists
            $userExists = Get-ADUser -Identity $user -ErrorAction SilentlyContinue
            if ($userExists) {
                # Add the user to the group
                Add-ADGroupMember -Identity $group -Members $user
                Write-Host "Successfully added $user to $group."
            }
            else {
                Write-Host "User $user does not exist in Active Directory."
            }
        }
        catch {
            Write-Host "Error adding $user to $group: $_"
        }
    }
}

# Add Admins to the Admin group
Add-UserToGroup -usersList $admins -group $adminGroup

# Add Users to the User group
Add-UserToGroup -usersList $users -group $userGroup

# Define passwords for admins
$passwords = @{
    "donkey" = "kurumi-tokisaki"
    "kataraa" = "CyberPatriot1!"
    "topha" = "j24#hj4H8J3!!!"
    "zukoa" = "klKL39@g29keY"
    "iroha" = "password"
}

# Define password for all users
$userPassword = "CyberPatriot1!"

# Function to set passwords for users
function Set-UserPassword($userName, $password) {
    try {
        # Set the password for the user
        Set-ADAccountPassword -Identity $userName -NewPassword (ConvertTo-SecureString -AsPlainText $password -Force) -Reset
        Write-Host "Successfully set password for $userName."
    }
    catch {
        Write-Host "Error setting password for $userName: $_"
    }
}

# Set passwords for Admins
foreach ($admin in $admins) {
    if ($passwords.ContainsKey($admin)) {
        Set-UserPassword -userName $admin -password $passwords[$admin]
    }
    else {
        Write-Host "No password defined for $admin. Skipping..."
    }
}

# Set password for all users in the Users list
foreach ($user in $users) {
    Set-UserPassword -userName $user -password $userPassword
}

# Define the group name
$groupName = "Pre-Windows 2000 Compatible Access"
$everyoneGroup = "Everyone"

# Check if the "Pre-Windows 2000 Compatible Access" group exists
$group = Get-ADGroup -Filter {Name -eq $groupName} -ErrorAction SilentlyContinue

if ($group) {
    try {
        # Add the "Everyone" group to the "Pre-Windows 2000 Compatible Access" group
        Add-ADGroupMember -Identity $groupName -Members $everyoneGroup
        Write-Host "Successfully added the 'Everyone' group to the '$groupName' group."
    }
    catch {
        Write-Host "Error adding 'Everyone' to '$groupName': $_"
    }
} else {
    Write-Host "The group '$groupName' does not exist in Active Directory."
}
# Get the SYSVOL share name
$sysvolShare = "\\$env:COMPUTERNAME\SYSVOL"

# Get the existing share details
$share = Get-WmiObject -Class Win32_Share | Where-Object { $_.Name -eq "SYSVOL" }

# Check if the SYSVOL share exists
if ($share) {
    # Add the "Everyone" group to the SYSVOL share with "Full Control"
    $shareName = $share.Name
    net share $shareName /grant:"Everyone,FULL"

    Write-Host "Successfully added 'Everyone' with Full Control to SYSVOL share permissions."
} else {
    Write-Host "SYSVOL share does not exist."
}

