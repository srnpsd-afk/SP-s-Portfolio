select * from [Nashville Housing]

select saledate, CONVERT(date,saledate)
from [Nashville Housing]

update [Nashville Housing]
set SaleDate = CONVERT(date,saledate)

Alter table [Nashville Housing]
add SaleDateConverted Date;

update [Nashville Housing]
set SaleDateConverted = CONVERT(date,saledate)

select saledateconverted from [Nashville Housing]

--PropertyAddress Correction

select *
from [Nashville Housing]
where PropertyAddress is null

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
from [Nashville Housing] a
join [Nashville Housing] b 
on a.ParcelID = b.ParcelID 
and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null

update a
set PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
from [Nashville Housing] a
join [Nashville Housing] b 
on a.ParcelID = b.ParcelID 
and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null


--Splitting Address

select PropertyAddress
from [Nashville Housing]

select 
SUBSTRING(propertyaddress,1,CHARINDEX(',',propertyaddress)-1) as Address,
SUBSTRING(propertyaddress,CHARINDEX(',',propertyaddress)+1 , LEN(propertyaddress)) as Address
from [Nashville Housing]

Alter table [Nashville Housing]
add propertysplitAddress nvarchar(255);

update [Nashville Housing]
set propertysplitaddress = SUBSTRING(propertyaddress,1, CHARINDEX(',', propertyaddress) -1)

Alter table [Nashville Housing]
add propertysplitcity nvarchar(255);

update [Nashville Housing]
set propertysplitcity = SUBSTRING(propertyaddress, CHARINDEX(',', propertyaddress)+1 , LEN(propertyaddress))


select *
from [Nashville Housing]


--Split Owner address

select OwnerAddress
from [Nashville Housing]

select 
PARSENAME(replace(OwnerAddress, ',', '.'), 3),
PARSENAME(replace(OwnerAddress, ',', '.'), 2),
PARSENAME(replace(OwnerAddress, ',', '.'), 1)
from [Nashville Housing]

Alter table [Nashville Housing]
add OwnersplitAddress nvarchar(255);

update [Nashville Housing]
set Ownersplitaddress = PARSENAME(replace(OwnerAddress, ',', '.'), 3)

Alter table [Nashville Housing]
add Ownersplitcity nvarchar(255);

update [Nashville Housing]
set Ownersplitcity = PARSENAME(replace(OwnerAddress, ',', '.'), 2)

Alter table [Nashville Housing]
add Ownersplitstate nvarchar(255);

update [Nashville Housing]
set Ownersplitstate = PARSENAME(replace(OwnerAddress, ',', '.'), 1)

select *
from [Nashville Housing]



--Change to Y n N in SoldAsvacant

select distinct(soldasvacant), count(soldasvacant)
from [Nashville Housing]
group by soldasvacant
order by 2


select (soldasvacant),
CASE when soldasvacant = 'Y' then 'Yes'
	when soldasvacant = 'N' then 'No'
	else SoldAsVacant
	END
from [Nashville Housing]


update [Nashville Housing]
set SoldAsVacant = CASE when soldasvacant = 'Y' then 'Yes'
	when soldasvacant = 'N' then 'No'
	else SoldAsVacant
	END

	

--Remove Duplicates

with RowNumCTE as(
select *,
ROW_NUMBER() OVER (
PARTITION BY parcelid, 
			propertyaddress, 
			saleprice, 
			saledate, 
			legalreference
			ORDER BY uniqueid
			) row_num
from [Nashville Housing]
)
select *
from RowNumCTE
where row_num>1
order by PropertyAddress

--deletion
with RowNumCTE as(
select *,
ROW_NUMBER() OVER (
PARTITION BY parcelid, 
			propertyaddress, 
			saleprice, 
			saledate, 
			legalreference
			ORDER BY uniqueid
			) row_num
from [Nashville Housing]
)
delete
from RowNumCTE
where row_num>1
--order by PropertyAddress



--Delete Unused Columns

select *
from [Nashville Housing]

alter table [Nashville Housing]
	drop column owneraddress, taxdistrict, propertyaddress

alter table [Nashville Housing]
	drop column saledate