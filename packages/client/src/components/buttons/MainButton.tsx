import React, { ReactNode } from 'react';
import { cn } from '../../utils/cn';

interface MainButtonProps {
  children: ReactNode;
  disabled?: boolean;
  onClick?: () => void;
}

const MainButton: React.FC<MainButtonProps> = ({ children, disabled = false, onClick = () => null }) => {
  return (
    <button onClick={onClick} disabled={disabled} className={cn('text-center  bg-dusty- py-2 font-normal text-3xl leading-[38px] uppercase w-full',{
      ['bg-dusty-orange text-night']: !disabled,
      ['bg-night text-rust border border-cedar']: disabled,
    })}>
      {children}
    </button>
  )
}

export default MainButton