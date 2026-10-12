# Add-NewHires.ps1 - creates new users from a CSV file
# Author: Jared Carlson

# Ask once for the temporary password
$password = Read-Host "Temporary password" -AsSecureString

# Go through each row in the CSV
foreach ($user in Import-Csv C:\Scripts\new_hires.csv) {

    # Create the user in their department OU
    New-ADUser -Name $user.Name -SamAccountName $user.Username `
        -Path "OU=$($user.Department),OU=Staff,OU=Carlson Retail,DC=carlson,DC=lab" `
        -AccountPassword $password -ChangePasswordAtLogon $true -Enabled $true

    # Add them to their department group (for example GG-Sales)
    Add-ADGroupMember -Identity "GG-$($user.Department)" -Members $user.Username

    Write-Host "Created $($user.Name)"
}
