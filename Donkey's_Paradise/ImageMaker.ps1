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

Write-Host "Script completed."
