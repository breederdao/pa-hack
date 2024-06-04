import MainButton from "./components/buttons/MainButton"

export interface IKingOfTheHillData {
  timer?: number;
  runningTime?: number;
  currentKing?: string;
  claimable: boolean;
  receiveable: boolean;
}

interface KingOfTheHillProps {
  data: IKingOfTheHillData;
}

const KingOfTheHill: React.FC<KingOfTheHillProps> = ({ data }): JSX.Element => {
  return (
    <>
      <div className='border-[1px] border-dusty-orange mb-6'>
        <h3 className="text-walnut text-base leading-6 font-normal text-center">Prize pool</h3>
        <h2 className='text-dusty-orange font-normal text-3xl leading-[38px] text-center border-b-2 border-dusty-orange'>1 Frontier Chip/s</h2>
        
        <div className='flex flex-row justify-between'>
          <div className='w-1/2 border-r border-dusty-orange'>
            <h3 className="text-walnut text-base leading-6 font-normal text-center">Timer</h3>
            <h2 className='text-dusty-orange font-normal text-3xl leading-[38px] text-center'>--:--</h2>
          </div>
          <div className='w-1/2 border-l border-dusty-orange'>
            <h3 className="text-walnut text-base leading-6 font-normal text-center">Running Time</h3>
            <h2 className='text-dusty-orange font-normal text-3xl leading-[38px] text-center'>--:--:--</h2>
          </div>
        </div>
      </div>

      <h2 className='text-rust font-normal text-xl leading-7 text-center'>Current King</h2>
      <div className="border-cedar border bg-night px-4 py-2 text- mb-6 text-center">
        <span className='text-dusty-orange font-bold text-2xl leading-8'>
          {data.currentKing}
        </span>
      </div>

      <p className='font-normal text-sm leading-[22px] font-courier mb-6'>
        Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.
      </p>

      <p className='font-normal text-lg leading-[26px] text-center'>Deposit 1 frontier chip to claim</p>
      <MainButton>Claim the throne</MainButton>
    </>
  )
}

export default KingOfTheHill