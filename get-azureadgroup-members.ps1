# Connect to Azure Active Directory
Connect-AzureAD

# Get the current date in "MM-dd-yyyy" format
$date = Get-Date -Format "MM-dd-yyyy"

# Initialize an array to store the members of the groups
$usersToReview = @()

# Get Azure AD groups that contain the name "PIM"
$groups = Get-AzureADGroup -SearchString "PIM"

# For each group, get the members and create a new object with the group name, member name, user principal name, and department
foreach ($group in $groups) {
    $members = Get-AzureADGroupMember -ObjectId $group.ObjectId

    foreach ($member in $members) {
        $users = [pscustomobject]@{
            GroupName = $group.DisplayName
            GroupDescription = $group.Description
            GroupObjectId = $group.ObjectId
            MemberName = $member.DisplayName
            MemberUPN = $member.UserPrincipalName
            MemberObjectID = $member.ObjectId
        }

        # Add the new user object to the array
        $usersToReview += $users
    }
}

# Export the array to a CSV file
$usersToReview | Export-Csv -Path ".\PIMGroupsAccessReview-$date.csv" -NoTypeInformation