--cleaning daTA
SELECT*
FROM PortfolioProject1.dbo.NashVilleHousing

--STANDARDIZE DATE FORMAT
SELECT SaleDate , CONVERT (date,SaleDate)
FROM PortfolioProject1.dbo.NashVilleHousing 

update NashVilleHousing
SET SaleDate = CONVERT (date,SaleDate)

ALTER TABLE NashVilleHousing
ADD SaleDateConverted Date;

update NashVilleHousing
SET SaleDate = CONVERT (date,SaleDate)

--POPULATE PROPERTY ADDRESS 
SELECT*
FROM PortfolioProject1.dbo.NashVilleHousing
ORDER BY ParcelID

SELECT a.ParcelID, a.PropertyAddress,b.ParcelID ,b.PropertyAddress ,ISNULL (a.PropertyAddress,b.PropertyAddress)
FROM PortfolioProject1.dbo.NashVilleHousing a
JOIN PortfolioProject1.dbo.NashVilleHousing b
on a.ParcelID =b.ParcelID
AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is NULL

Update a
SET PropertyAddress = ISNULL (a.PropertyAddress,b.PropertyAddress)
FROM PortfolioProject1.dbo.NashVilleHousing a
JOIN PortfolioProject1.dbo.NashVilleHousing b
on a.ParcelID =b.ParcelID
AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is NULL

--breaking address into indivual parts
SELECT PropertyAddress
FROM PortfolioProject1.dbo.NashVilleHousing

SELECT 
SUBSTRING(PropertyAddress,1, CHARINDEX (',', PropertyAddress )-1) 
SUBSTRING(PropertyAddress , CHARINDEX ( ',', PropertyAddress )+1 , LEN PropertyAddress)) as address
FROM PortfolioProject1.dbo.NashVilleHousing

ALTER table NashVilleHousing
ADD PropertySplitAddress nvarchar(255);
 
Update NashVilleHousing
SET PropertySplitAddress =SUBSTRING(PropertyAddress ,1, CHARINDEX (',' , PropertyAddress )-1) 

ALTER table NashVilleHousing
ADD PropertySplitCity nvarchar(255);
 
Update NashVilleHousing
SET PropertySplitCity =SUBSTRING(PropertyAddress , CHARINDEX (',' , PropertyAddress )+1 , LEN PropertyAddress)) as address



--sold as vacant y and n yo yes and no

SELECT distinct (SoldAsVacant),COUNT (SoldAsVacant)
FROM PortfolioProject1.dbo.NashVilleHousing
group by SoldAsVacant
order by 2

 select SoldAsVacant
 ,case when SoldAsVacant ='Y' then 'YES'
       when SoldAsVacant ='N' then 'NO'
  else SoldAsVacant
  end
FROM PortfolioProject1.dbo.NashVilleHousing


Update NashvilleHousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END








