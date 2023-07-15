/*
Title: Data Cleaning for Nashville Housing Data
Data Analyst: Peace Okpala
Total Number of Observations : 56,477
SKILLS: Handling Missing Data, PARSENAME, SUBSTRING, Case, Handling Duplicates, CTE'S, Windows Function.
*/

--Viewing all data in the table.

SELECT *
FROM NashvilleData..NVHousing

------------------------------------------------------
-- Reformat the Dates to remove the hour,minutes and seconds data. This will reduce redundancy in the data

SELECT SaleDateNew, CONVERT(Date,SaleDate)
FROM NashvileData..NVHousing

ALTER TABLE NVHousing
ADD SaleDateNew Date;

UPDATE NVHousing
SET SaleDateNew = CONVERT(Date, SaleDate)
	
 
 --Checking for Missing Data in the Property Address Column
 SELECT *
 FROM NashvileData..NVHousing
 WHERE PropertyAddress IS NULL
 ORDER BY ParcelID;
 
 -- Replacing Missing Data

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM NashvileData..NVHousing a
JOIN NashvileData..NVHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL

--Updating Property Address
UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM NashvileData..NVHousing a
JOIN NashvileData..NVHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL

----------------------------------------------------	

-- Breaking out Address into Individual Columns (Address, City, State)


SELECT PropertyAddress
FROM NashvileData..NVHousing

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address

FROM NashvileData..NVHousing


ALTER TABLE NVHousing
ADD PropertyAddress Nvarchar(300);

UPDATE NVHousing
SET PropertyAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )


ALTER TABLE NVHousing
ADD PropertyCity Nvarchar(300);

Update NVHousing
SET PropertyCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))

-----------------------------------------------------
-- Using PARSENAME to Break Out OwnerAddress into Individual Columns

SELECT OwnerAddress
FROM NashvileData..NVHousing



SELECT
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
FROM NashvileData..NVHousing


ALTER TABLE NVHousing
ADD OwnerSplitAddress Nvarchar (300);

UPDATE NVHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE NVHousing
ADD OwnerCity Nvarchar(300);

UPDATE NVHousing
SET OwnerCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)


ALTER TABLE NVHousing
ADD OwnerState Nvarchar(300);

UPDATE NVHousing
SET OwnerState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)

----------------------------------------
	
/* USING CASE FUNCTION
-- Changing Y and N to 'Yes' and 'No' from 'Sold as Vacant' Column. 
-- The data had Y,N, Yes and No values. Doing this change will eliminate duplicates.
*/

SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM NashvileData..NVHousing
GROUP by SoldAsVacant
ORDER BY 2

SELECT SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
FROM NashvileData..NVHousing


UPDATE NVHousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END

-----------------------------------
-- Removing Duplicates USING CTE and Windows Function.
/*
The standard practice is to ensure that you don't remove
duplicates from the actual database. Duplicate removal should be done on a temporary 
database.
*/

WITH RowNumCTE AS(
SELECT *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

FROM NashvileData..NVHousing
)
SELECT *
FROM RowNumCTE
WHERE row_num > 1
ORDER BY PropertyAddress

DELETE
FROM RowNumCTE
WHERE row_num > 1


SELECT *
FROM NashvileData..NVHousing


-------------------------------------

/*
-- Deleting Unused Columns. The best practice is not to delete any column from the 
raw data. It is better to delete from temporary data.
*/


SELECT *
FROM NashvileData..NVHousing


ALTER TABLE NashvileData..NVHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate
